#!/usr/bin/env bash
# Run scraper script on each GSA GitHub organization
# Define each organization in a config.ORGNAME.json file

configs=$(find -maxdepth 1 -name 'config.*.json')

if [ -z "$configs" ] ; then
  echo "Please create at least one config file (see https://github.com/LLNL/scraper for details)."
  exit 1
fi

echo "Using configs: $(echo $configs | tr -d '\n')"

for config in $configs ; do
  outfile=$(echo $config | sed 's/config/code/')
  scraper --config $config --output-filename $outfile --skip-labor-hours
done

