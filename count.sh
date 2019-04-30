#!/usr/bin/env bash

if [ ! -f "$1" ] ; then
  echo "Usage: $0 JSONFILE"
  exit
fi

jsonfile=$1
total=$(jq '.releases | length' ${jsonfile})
usage_types=$(jq '.releases[].permissions.usageType' ${jsonfile} | sort | uniq)

for usage_type in ${usage_types} ; do
  usage_type_count=$(jq '.releases[].permissions.usageType' ${jsonfile} | grep ${usage_type} | wc -l)
  usage_type_percentage=$(echo "scale=2; 100 * ${usage_type_count} / ${total}" | bc)
  output="${output}\n${usage_type}: ${usage_type_count} (${usage_type_percentage}%)"
done

output="${output}\nTotal: ${total}"

echo -e ${output} | column -t