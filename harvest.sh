#!/usr/bin/env bash

# Format: DISPLAY_NAME,GITHUB_ORG_NAME
ORGS=(
  GSA,GSA
  18F,18F
  PIF,presidential-innovation-fellows
  USWDS,USWDS
)

output_file=$1

if [ -z "${output_file}" ] ; then
  echo "Usage: $0 OUTPUT_FILE"
  exit 1
fi

if [ -e "${output_file}" ] ; then
  echo "${output_file}: File already exists; refusing to overwrite"
  exit 1
fi

if [ -z "${GITHUB_ACCESS_TOKEN}" ] ; then
  echo "Please set your GITHUB_ACCESS_TOKEN environment variable."
  exit 1
fi

timestamp=$(date +%Y%M%d%H%M%S)
rate_limit_pause_mins=15

get_rate_limits() {
  local headers=$(curl -I -s -u :$GITHUB_ACCESS_TOKEN https://api.github.com/rate_limit)
  api_limit=$(echo "$headers" | grep '^X-RateLimit-Limit' | cut -f2 -d' ' | tr -d '\r\n')
  api_remaining=$(echo "$headers" | grep '^X-RateLimit-Remaining' | cut -f2 -d' ' | tr -d '\r\n')
  api_reset=$(echo "$headers" | grep '^X-RateLimit-Reset' | cut -f2 -d' ' | tr -d '\r\n')
}

for org in ${ORGS[@]} ; do
  # Sleep for a bit if we hit 50% of our rate limit quota
  get_rate_limits
  if [ $(($api_limit / $api_remaining)) -ge 2 ] ; then
    now=$(date +%s | tr -d '\r\n')
    delta_s=$(($api_reset - $now))
    delta_m=$(($delta_s / 60 + 1))
    echo "Waiting for API rate limit window to reset due to API rate limiting"
    echo "Window resets at: $(date -r $api_reset)"
    echo "Current time:     $(date -r $now)"
    echo -n "Waiting ${delta_m}m:"
    for ((i = 1; i <= delta_m; i++)) ; do
      sleep 60
      echo -n " $(($delta_m - $i))..."
    done
    echo
  fi

  display_name=$(echo $org | cut -f1 -d,)
  github_name=$(echo $org | cut -f2 -d,)
  jsonfile=/tmp/$github_name.${timestamp}.json

  echo -n "Building inventory for '$display_name' organization... "
  codeinv github $github_name -n $display_name -a ${GITHUB_ACCESS_TOKEN} > $jsonfile
  echo $jsonfile
  jsonfiles="$jsonfiles $jsonfile"
done

echo -n "Combining files... "
codeinv combine GSA -r $jsonfiles > $output_file
echo $output_file
echo "Done!"
