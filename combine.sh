#!/usr/bin/env bash
# Combines multiple scraper output files into a final code.json

input_files=code.*.json
output_file=code.json

jq -s '.[0] as $first_file | { agency: "GSA", version: $first_file.version, measurementType: $first_file.measurementType, releases: [.[].releases[]] }' ${input_files} > ${output_file}

echo "Created ${output_file}"

total=$(jq '.releases | length' ${output_file})
usage_types=$(jq '.releases[].permissions.usageType' ${output_file} | sort | uniq)

for usage_type in ${usage_types} ; do
  usage_type_count=$(jq '.releases[].permissions.usageType' ${output_file} | grep ${usage_type} | wc -l)
  usage_type_percentage=$(echo "scale=2; 100 * ${usage_type_count} / ${total}" | bc)
  output="${output}\n${usage_type}: ${usage_type_count} (${usage_type_percentage}%)"
done

output="${output}\nTotal: ${total}"

echo -e ${output} | column -t
