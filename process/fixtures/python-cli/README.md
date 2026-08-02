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

## Notes

It is run from cron on the reporting box and the output is piped into the nightly mail. That is
the only caller, so the output format is load-bearing — if you change the columns, change the
mail template with it.
