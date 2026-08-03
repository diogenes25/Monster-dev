# salesreport

Reads a sales CSV and prints a per-region summary. Standard library only.

```
python report.py sales.csv
```

```
Region             Orders          Total
East                    1         210.00
North                   2         165.75
South                   2         149.10
```

The CSV needs `region` and `amount` columns; anything else in it is ignored.

## HTML output

```
python report.py sales.csv --html report.html
```

Writes the same summary as a standalone HTML page, together with the image asset the
page references. The stdout report above is printed either way, so adding `--html`
does not change what the cron job mails.

## Notes

It is run from cron on the reporting box and the output is piped into the nightly mail.
