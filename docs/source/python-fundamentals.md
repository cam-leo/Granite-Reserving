# Python Fundamentals

A reserve review often starts by checking claim payments against a control total. The example below uses one dictionary per payment and adds payments for the same accident year. The amounts are in whole Canadian dollars.

## Group and sum payments

```python
from collections import defaultdict

payments = [
    {"accident_year": 2023, "paid": 400},
    {"accident_year": 2023, "paid": 600},
    {"accident_year": 2024, "paid": 800},
]

paid_by_year = defaultdict(int)

for payment in payments:
    year = payment["accident_year"]
    paid_by_year[year] += payment["paid"]

for year, paid in sorted(paid_by_year.items()):
    print(f"{year}: {paid:,}")
```

```text
2023: 1,000
2024: 800
```

In Excel, create a PivotTable with **Accident Year** in Rows and **Sum of Paid** in Values. The Python dictionary stores the same subtotals. Check that the grouped payments add up to the original total of 1,800 CAD.

## Add development age

Grouping by accident year and development age produces the cells of an incremental triangle. [Data Preparation](data-preparation.md) shows how those cells become cumulative paid amounts.
