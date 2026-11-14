# Excel to Python

Use a small fictional claims dataset to practice the same calculations in Excel and Python. Each row represents one claim at a single valuation date. Amounts are in Canadian dollars, and the example has one row per claim ID.

| claim_id | accident_year | line | paid | case_outstanding | status |
| --- | ---: | --- | ---: | ---: | --- |
| CL-001 | 2023 | Auto | 400 | 0 | Closed |
| CL-002 | 2023 | Property | 600 | 200 | Open |
| CL-003 | 2024 | Auto | 800 | 300 | Open |
| CL-004 | 2024 | Property | 200 | 0 | Closed |

## Match each Excel task to pandas

Use an Excel table named `Claims` with the column names shown above. In Python, install pandas with `python -m pip install pandas`, then run the example below.

| Task | Excel | pandas |
| --- | --- | --- |
| Add paid and case outstanding to get incurred claims | `=[@paid]+[@case_outstanding]` | Add the two columns |
| Look up the paid amount for CL-003 | `=XLOOKUP("CL-003",Claims[claim_id],Claims[paid])` | Set the claim ID as the index and look it up with `.loc` |
| Sum 2024 Auto payments | `=SUMIFS(Claims[paid],Claims[accident_year],2024,Claims[line],"Auto")` | Select matching rows and use `.sum()` |
| Count open claims from 2024 | `=COUNTIFS(Claims[accident_year],2024,Claims[status],"Open")` | Count the true values in a Boolean filter |
| Summarize payments by year and line | PivotTable with accident year in Rows, line in Columns, and Sum of paid in Values | Use `.pivot_table()` with sum as the aggregation |

```python
from io import StringIO

import pandas as pd

claims = pd.read_csv(StringIO("""claim_id,accident_year,line,paid,case_outstanding,status
CL-001,2023,Auto,400,0,Closed
CL-002,2023,Property,600,200,Open
CL-003,2024,Auto,800,300,Open
CL-004,2024,Property,200,0,Closed
"""))

claims["incurred"] = claims["paid"] + claims["case_outstanding"]
paid_for_claim = claims.set_index("claim_id").loc["CL-003", "paid"]

is_2024 = claims["accident_year"].eq(2024)
is_auto = claims["line"].eq("Auto")
is_open = claims["status"].eq("Open")
paid_2024_auto = claims.loc[is_2024 & is_auto, "paid"].sum()
open_2024_count = (is_2024 & is_open).sum()

paid_by_year_and_line = claims.pivot_table(
    index="accident_year", columns="line", values="paid", aggfunc="sum", fill_value=0
)

print(claims[["claim_id", "incurred"]].to_string(index=False))
print(f"Paid for CL-003: {paid_for_claim:,}")
print(f"2024 Auto paid: {paid_2024_auto:,}")
print(f"2024 open claims: {open_2024_count}")
print(paid_by_year_and_line)
```

Check that CL-003 has 800 CAD paid and 1,100 CAD incurred, 2024 Auto paid totals 800 CAD, and there is one open claim from 2024. The four PivotTable cells should add up to the original paid total of 2,000 CAD.

Next, [Actuarial Analysis](actuarial-analysis.md) uses grouped claims data to build development triangles and estimate unpaid claims.
