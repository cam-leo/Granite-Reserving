# Actuarial Analysis

Work through a reserving dataset in Python, starting with either Schedule P or the XYZ Insurer example. The dataset choice is open.

1. Inspect the data, reconcile totals, and build a cumulative claims development triangle.
2. Implement chain ladder and Bornhuetter–Ferguson (BF) step by step in Python. Compare development factors, assumptions, and unpaid claims estimates with a spreadsheet calculation.
3. Repeat the analysis with the [`chainladder` package](https://chainladder-python.readthedocs.io/stable/). Reconcile the results using the same inputs and selections, then explore other packages as needed.

The examples below introduce triangles and paid chain ladder using a small fictional dataset.

```{toctree}
:maxdepth: 1

data-preparation
reserving-methods
case-studies
```

Next, [Granite Reserving Project](granite-reserving-project.md) applies the workflow to a fictional insurer's year-end reserve review.
