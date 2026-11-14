# Data Preparation

A paid triangle shows how claims from each accident year accumulate as they mature. Use a consistent valuation cutoff, currency, and definition of paid losses across the triangle.

## Build a cumulative paid triangle

1. Identify each transaction and check for duplicate records. Keep valid reversals and adjustments with their original signs.
2. Apply the valuation cutoff to the payment records. Reconcile counts and signed paid amounts to source totals on the same basis.
3. Assign accident year from the loss date and development age from the payment date under a documented convention. In this annual example, payments in the accident calendar year go into the 12-month bucket. Payments in the next calendar year go into the 24-month bucket.
4. Sum incremental paid amounts by accident year and development age, then accumulate across each row.

## Check the result

Suppose the 2023 accident year has 1,000 CAD of payments by 12 months and another 500 CAD by 24 months. The 2024 accident year has 800 CAD of payments by 12 months. At December 31, 2024, the cumulative amounts are

| Accident year | 12 months | 24 months |
| --- | ---: | ---: |
| 2023 | 1,000 | 1,500 |
| 2024 | 800 | |

The blank cell is a future observation. A zero incremental cell represents an observed period with no net payment activity. The latest observed cumulative cells sum to 2,300 CAD, the control total to reconcile for this triangle.

Use the matched observations to estimate a development factor in [Reserving Methods](reserving-methods.md).
