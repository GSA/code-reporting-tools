#!/bin/sh

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

echo -n "Building inventory for 'GSA' organization... "
codeinv github GSA -a ${GITHUB_ACCESS_TOKEN} > /tmp/gsa.${timestamp}.json
echo "/tmp/gsa.${timestamp}.json"

echo -n "Building inventory for '18F' organization... "
codeinv github 18F -a ${GITHUB_ACCESS_TOKEN} > /tmp/18f.${timestamp}.json
echo "/tmp/18f.${timestamp}.json"

echo -n "Building inventory for 'presidential-innovation-fellows' organization... "
codeinv github presidential-innovation-fellows -n PIF -a ${GITHUB_ACCESS_TOKEN} > /tmp/pif.${timestamp}.json
echo "/tmp/18f.${timestamp}.json"

echo -n "Building inventory for 'USWDS' organization... "
codeinv github USWDS -a ${GITHUB_ACCESS_TOKEN} > /tmp/uswds.${timestamp}.json
echo "/tmp/18f.${timestamp}.json"

echo -n "Combining files... "
codeinv combine GSA -r /tmp/gsa.${timestamp}.json /tmp/18f.${timestamp}.json /tmp/pif.${timestamp}.json /tmp/uswds.${timestamp}.json > ${output_file}
echo "${output_file}"
echo "Done!"
