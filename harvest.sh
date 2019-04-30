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

for org in ${ORGS[@]} ; do
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
