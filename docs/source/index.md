# Python for Actuaries

This is my personal handbook on learning Python and AI currently as a junior Actuarial Associate working in P&C. The lessons will centre around a fictional insurer named "Granite Reserving". The goal is to re-develop my Python and AI skills to the point where I can carry out my usual Excel workflows utilizing Python to enhance efficiency. 

I'll first go into the basics and fundamentals of Python, and then proceed on learning how to manipulate data in Python. I will base my work off on Excel functions, and use common libraries like Pandas, SciKit, as well as the chain ladder package. 

Afterwards, I'll take a look at how to actually incorporate this Python workflow into actual daily or monthly work practices. I want to be able to automate monthly processes as well as be able to procure ad-hoc reports when required. The goal should be to improve efficiency while reducing any chance for human error.

Finally, I want to do a deep-dive into how AI can affect our work; how I can use it to either make my workflow more efficient, or discover new ideas and findings that will allow me to produce more accurate and sustainable results.

Step 1: Let's begin with the Python basics: [Getting Started](getting-started.md) for a tour of the reserve review. If you already work with claims in spreadsheets, [Python Fundamentals](python-fundamentals.md) shows how to translate a familiar task into code.

| Section | What you'll find |
| --- | --- |
| [Getting Started](getting-started.md) | The reserve review workflow and the terms used throughout the guide. |
| [Python Fundamentals](python-fundamentals.md) | A runnable example of aggregating claim payments by accident year. |
| [Data Preparation](data-preparation.md) | How to reconcile transactions and build a cumulative paid triangle. |
| [Reserving Methods](reserving-methods.md) | A worked chain ladder calculation and the assumptions behind it. |
| [Case Studies](case-studies.md) | A synthetic example of how a change in payment speed affects the estimate. |

```{toctree}
:hidden:
:maxdepth: 2

getting-started
python-fundamentals
data-preparation
reserving-methods
case-studies
```
