#!/usr/bin/env bash
# Run scraper script on each GSA GitHub organization

scraper --config config.gsa.json --output-filename code.gsa.json
scraper --config config.18f.json --output-filename code.18f.json
scraper --config config.pif.json --output-filename code.pif.json
scraper --config config.uswds.json --output-filename code.uswds.json
