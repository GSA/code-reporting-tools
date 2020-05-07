#!/usr/bin/env bash
# Run scraper script on each GSA GitHub organization

scraper --config config.gsa.json --output-filename code.gsa.json --skip-labor-hours
scraper --config config.18f.json --output-filename code.18f.json --skip-labor-hours
scraper --config config.pif.json --output-filename code.pif.json --skip-labor-hours
scraper --config config.uswds.json --output-filename code.uswds.json --skip-labor-hours
