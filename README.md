# Granite-Reserving
My personal exploratory project in reserving

A full year-end reserve review of a fictional mid-sized Canadian P&C insurer, Granite Lantern Insurance, with pricing and capital built around it: simulated claim data, triangles, Exam 5 methods, Exam 7 stochastic reserving, reinsurance, IFRS 17, rate indications and ERM. All data is made up.

- [Project scope](docs/SCOPE.md)

## Saving your work to GitHub

Open PowerShell in this folder and run:

```
.\publish.cmd
```

It lists what changed, asks for a commit message (press Enter for "Update"), then commits and pushes. It stops without uploading anything if a key or password file, or a file over 50 MB, is about to go up. Nothing is sent unless you run it.

The same thing by hand:

```
git add .
git commit -m "Describe what changed"
git push
```

Generated data (`data/`, Parquet and CSV files) is ignored on purpose. The simulator uses a fixed seed, so anyone can rebuild it exactly.
