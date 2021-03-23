# Code Reporting Tools

This repository contains various tools to support GSA's compliance with the Federal Source Code Policy.

## `gsa-scraper.sh` (Scraper)

Builds multiple `code.*.json` files (one per GSA organization) using the [LLNL Scraper](https://github.com/LLNL/scraper) tool. As a prerequisite, you need to have `scraper` installed, which you can accomplish by running `pip install -r requirements.txt`. You should also have a config file named `config.ORG_NAME.json` for each GitHub organization you want to scan. See the [LLNL Scraper docs](https://github.com/LLNL/scraper#config-file-options) for information on the config file format.

## `combine.sh`

Combines multiple organizational `code.*.json` files into a single agency-wide `code.json`.

## `harvest.sh` (CodeInventory)

Builds a `code.json` file using the [CodeInventory](https://github.com/GSA/codeinventory) tool. The `codeinventory` and `codeinventory-github` Ruby gems must be installed.

Usage:

```bash
# outputs a combined code.json for GSA, 18F, PIF, and USWDS organizations
harvest.sh code.json
```

## `count.sh`

Summarizes the usage types across all releases.

Usage:

```bash
# outputs statistics from an existing code.json file
count.sh code.json
```
