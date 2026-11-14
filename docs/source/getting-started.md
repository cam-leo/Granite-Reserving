# Getting Started

Granite Reserving is a learning project built around a year-end reserve review of Granite Lantern Insurance, a fictional Canadian property and casualty insurer. All figures in this guide are synthetic.

## Follow the reserve review

1. Set the **valuation date** and define the portfolio, currency and loss measure.
2. Reconcile claim transactions to source totals, then group them by **accident year** and **development age**. See [Data Preparation](data-preparation.md).
3. Use the cumulative paid triangle to estimate **ultimate claims**, the total expected payments after all claims have settled. See [Reserving Methods](reserving-methods.md).
4. Subtract cumulative paid claims as of the valuation date to estimate **unpaid claims**. Review how much the estimate changes when the assumptions change. See [Case Studies](case-studies.md).

## Run the first example

[Python Fundamentals](python-fundamentals.md) runs with Python 3 and its standard library. Copy the example into a file named `paid_by_year.py` and run `python paid_by_year.py`. On Windows you can also use `py paid_by_year.py`.

For the full simulation and research plan, see [the project scope](https://github.com/cam-leo/Granite-Reserving/blob/main/docs/SCOPE-v2.md).
