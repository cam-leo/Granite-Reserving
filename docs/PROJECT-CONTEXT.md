# Granite Reserving: Context for a New Chat

Read this first, then [SCOPE.md](SCOPE.md) for the full plan. Last updated October 2, 2026.

## Who and what

Leo is an actuarial student (CAS track) who works with Excel at his day job and wants to apply everything from the exams and his university courses (UTSC) in one big project. This repo is that project: a full year-end reserve review of a fictional carrier, with pricing and capital built around it. It is a personal learning project, so understanding matters more than speed.

- **The carrier:** Granite Lantern Insurance, a made-up mid-sized Canadian P&C insurer. About $750M CAD of gross written premium, 7 lines, accident years 2011 to 2025, valuation date December 31, 2025.
- **The scope:** every CAS exam from P to 9 and his math, stats and CS courses. Reserving is the core (Exams 5 and 7); pricing (Exams 5, 8, PCPA) and capital and ERM (Exams 6C and 9) are phases 7 and 8.
- **Tools:** Python for the heavy work (polars or DuckDB on Parquet, pandas, statsmodels, PyMC or Stan, chainladder-python as a cross-check) and Excel for the judgment calls (selections), with Python writing the workbooks and reading the selections back.
- **Timeline:** starts after his MAS-I sitting on October 28, 2026. Eight phases, each with a pass or fail gate; the reserving core runs about a year (see the roadmap in SCOPE.md).

## The key design idea

The simulator generates claims one at a time, with every payment and reserve change as its own transaction, and it also writes a **sealed true ultimate** for every claim. That lets every method be scored against the truth at the end, which real reserving can't do. Protect this:

- Simulate claim processes, not development factors, or chain ladder will look perfect and prove nothing.
- Plant known changes (case reserve strengthening, a claims system change, a benefit reform, calendar-year inflation) and data errors, and log them in a hidden file that is only opened at the end.
- Keep the truth sealed until Leo's selections are final.
- Use a fixed random seed so the whole company rebuilds exactly.

## Working rules (important)

- **Leo makes every commit and push himself.** Never run `git commit` or `git push`, never create commits, and never push to his repos. Write or edit files and tell him what changed. He saves work with `.\publish.cmd` in PowerShell (it asks for a commit message, commits and pushes, and refuses to upload keys or files over 50 MB).
- **Don't change files outside what he asked for.** He reviews everything before committing.
- **Everything is fictional.** Never use real company data from his job or anything that resembles it.
- **Never put keys, passwords or tokens in files or chat.** Don't create accounts or sign in for him.
- **He's on Windows**, with the repo at `~/OneDrive/Desktop/Granite-Reserving` and files edited through the Claude desktop link, so keep Windows line endings (CRLF) in files you write there.
- **Style:** plain language, short answers, explain the actuarial reasoning when it's a choice he'll have to defend. He knows the exam material, so reference readings by author and year (for example Mack 1994, Friedland, Clark 2003) rather than re-teaching them.

## Where things stand

- Done: the scope document, the 8-phase roadmap, the GitHub repo, `README.md`, `.gitignore` and `publish.cmd`.
- Not started: any code. The repo has no folders other than `docs/`.
- Open question: whether to stay Canadian everywhere or add a small US branch for readings that don't fit Canada (workers' comp is provincial, large-deductible and retro plans are rare). Current answer: stay Canadian, and keep the Siewert, Teng and Perkins, and retro-plan material as a small, clearly labelled commercial book.

## Planned layout

```
config/        assumptions in YAML: segments, caps, tail choices, correlation
simulate/      the company generator (and the sealed truth)
data/          raw/, clean/, triangles/ as Parquet (git-ignored; rebuilt from the seed)
reserving/     methods/, stochastic/, reinsurance/, ifrs17/
pricing/       indications, GLM, layers, rating plans
capital/       cat model, reinsurance pricing, ERM
selections/    one Excel workbook per line, per valuation date
tests/         textbook examples reproduced to the dollar
notebooks/     exploration and diagnostics
report/        the reserve report, pricing memo and ERM summary
```

## Next steps

1. Create the folder skeleton and a Python environment (`pyproject.toml` or `requirements.txt`) with the fixed seed in `config/`.
2. Phase 1: write the simulator, starting with one line (personal auto physical damage), and check it ties to control totals and looks like Schedule P shapes.
3. Later: a page on his website (Leo's Log, under Actuarial, "The Big One") that links to this repo and shows the triangles and the reserve bridge.
