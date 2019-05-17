# Code Reporting Tools

The `harvest.sh` script is configured to run overnight quarterly on CircleCI to coincide with quarterly reporting requirements. The CI system produces a finished `code.json` file as an artifact. The scripts can also be run locally.

## `gsa-scraper.sh` (Scraper)

Builds multiple `code.*.json` files (one per GSA organization) using the [Scraper](https://github.com/LLNL/scraper) tool.

## `combine.sh`

Combines multiple organizational `code.*.json` files into a single agency-wide `code.json`.

## `harvest.sh` (CodeInventory)

Builds a `code.json` file using the [CodeInventory](https://github.com/GSA/codeinventory) tool. The `codeinventory` and `codeinventory-github` gems must be installed.

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
