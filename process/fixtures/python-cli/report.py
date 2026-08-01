"""Summarize a CSV of sales rows and print a report to stdout.

Usage: python report.py sales.csv
"""
import argparse
import csv
import sys
from collections import defaultdict


def summarize(path):
    totals = defaultdict(float)
    counts = defaultdict(int)
    with open(path, newline="", encoding="utf-8") as f:
        for row in csv.DictReader(f):
            region = row["region"]
            totals[region] += float(row["amount"])
            counts[region] += 1
    return totals, counts


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("csv_path", help="Path to a sales CSV with region,amount columns")
    args = parser.parse_args()

    totals, counts = summarize(args.csv_path)
    print(f"{'Region':<15}{'Orders':>10}{'Total':>15}")
    for region in sorted(totals):
        print(f"{region:<15}{counts[region]:>10}{totals[region]:>15.2f}")


if __name__ == "__main__":
    sys.exit(main())
