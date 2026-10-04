# Granite Reserving: Project Scope (v2)

**Last updated:** October 3, 2026
**Status:** Project specification. Supersedes the October 2 scope; Appendix A lists every change and the open decisions.
**Primary goal:** Build a realistic, reproducible, claim-level P&C environment, then use it to run a full year-end reserve review, a pricing program and a capital/ERM model, and to measure how actuarial methods perform when the underlying claims process changes.

**How to read this document.** The project is large on purpose: it applies every CAS exam from P to 9 and every relevant UTSC math, statistics and computer science course to one company. To keep it shippable, the work is split into a **Core release** (Tier 1, reserving), **research tiers** (Tier 2 and 3, advanced reserving) and two **extension tracks** (Pricing and Capital/ERM). Each has its own definition of done and its own gates. Nothing in Tier 2, Tier 3 or the tracks is a prerequisite for the Core release, and nothing in the Core release is weakened to make room for them.

---

## 1. Project purpose

The project runs a fictional mid-sized Canadian P&C insurer, **Granite Lantern Insurance**, through one year the way its actuarial department would. It starts with policy, exposure, claim and transaction data. It ends with a year-end reserve review, stochastic ranges, IFRS 17 outputs, a written Appointed-Actuary-style report, and (in the extension tracks) rate indications, rating plans, reinsurance and catastrophe pricing, an MCT calculation and an ERM model.

The project is deliberately broader than a triangle-method implementation. Its central purpose is to study the connection between:

> **the underlying claims process → the data it produces → the assumptions a method makes → the resulting estimate.**

Because the simulator keeps a sealed true ultimate for every claim (and sealed true rating relativities for every policy), the project can ask whether a method is actually accurate, unbiased and well calibrated across many simulated insurers. A real actuary can never do this.

### Central research question

> **How robust are traditional and stochastic P&C actuarial methods when the underlying claims process contains realistic structural changes, claims-handling changes, inflation, catastrophe losses, large losses, reinsurance, thin data and data-quality problems?**

### Secondary research questions

1. When the assumptions of chain ladder are approximately satisfied, how do the traditional methods compare?
2. Which methods are most robust to changes in case adequacy, disposal rates, inflation and regulatory reforms?
3. When are Bornhuetter-Ferguson, Cape Cod, Benktander, credibility and frequency-severity methods preferable to pure development methods?
4. How much does data cleaning change the ultimate reserve?
5. Do stochastic reserve ranges achieve their intended coverage against the sealed truth?
6. Do more complicated methods materially improve predictive accuracy, or only add complexity?
7. How does method performance differ between short-, medium- and long-tail business?
8. How do occurrence and claims-made business differ when modelled from claim-level processes? (Tier 2)
9. How much error comes from aggregating line-level reserve distributions with a simple correlation matrix instead of a process-based dependence structure?
10. How do reserve estimates translate into IFRS 17 liability measures and, as a separate exercise, into regulatory capital?
11. How much do human judgment selections add, compared with rule-based selection policies run over the same data?
12. How closely do pricing GLM relativities, credibility-weighted relativities and rate indications recover the sealed truth, and how does reserving error flow into rate indications? (Pricing track)
13. How do reserve, premium, catastrophe and interest-rate risk combine into capital by line, and how sensitive is that answer to the dependence structure and the risk measure? (Capital track)

---

## 2. The carrier

**Granite Lantern Insurance** is a fictional Canadian P&C insurer with about **$750M CAD of gross written premium in 2025**, growing about 4% a year.

| Line | Tail | Basis | GWP 2025 ($M) | Claims / year | Tier | Why it's in |
| --- | --- | --- | ---: | ---: | --- | --- |
| Personal auto: physical damage | Short | Occurrence | 110 | 45,000 | 1 | Fast, high-volume baseline; frequency trend and 2020 frequency drop; the vertical-slice line |
| Personal auto: bodily injury and accident benefits (Ontario) | Long | Occurrence | 190 | 9,000 | 1 | Benefit reform, slow settlement, large losses |
| Homeowners | Short | Occurrence | 160 | 22,000 | 1 | Catastrophes, seasonality, salvage and subrogation |
| Commercial property | Short to medium | Occurrence | 90 | 4,000 | 1 | Quota share and per-risk excess of loss |
| Commercial auto | Medium | Occurrence | 60 | 3,500 | 1 | Thin data, so credibility and frequency-severity matter |
| Commercial general liability | Long | Occurrence | 100 | 2,500 | 1 | Case-reserve strengthening, a deductible program |
| Professional liability (E&O, D&O) | Long | Claims-made | 40 | 600 | 2 | Report-year triangles, thin and volatile |

**Tier 1 portfolio (six occurrence lines):** $710M GWP and about 86,000 claims a year. **Full seven-line portfolio:** $750M and about 86,600 claims a year. The simulator is built seven-line-ready (the claims-made data model exists from day one), but Professional Liability is switched on only in Tier 2, so no Tier 1 figure, gate or exhibit depends on it.

Over the 15-year window this is roughly 1.0 to 1.3 million claims (about 1.0 million if claim counts grow with premium at 4% a year) and roughly 8 to 15 million transactions.

### Historical window

The core simulator covers 2011 to 2025, so the primary review can be done at December 31, 2025 and rolled forward from December 31, 2024. For long-tail lines and backtesting, the simulator may generate extra pre-2011 exposure, so long-tail lines have realistic development history without forcing every line onto the same window.

---

## 3. What "done" means

The project has three levels of completion:

- **Core release** = Tier 1 complete. This is the first public milestone.
- **Research complete** = Tiers 1 to 3 complete.
- **Project complete** = Tiers 1 to 3 plus the Pricing track and the Capital/ERM track.

### Tier 1: Core release (reserving, six occurrence lines)

1. A reproducible claim-level simulator with a sealed true ultimate, acceptance-tested against Schedule P-shaped realism targets (section 5).
2. A clean claim, policy and transaction warehouse with hard, component-level reconciliation guardrails (G1, section 9).
3. Automated data-quality detection, a resolution rule for every planted issue, and a quantitative data-quality bridge.
4. A triangle library: paid, incurred, reported counts, closed counts, closed-without-payment, ALAE, salvage/subrogation, gross/ceded/net, plus diagnostics.
5. A deterministic method engine (the Exam 5 suite) that exports **explicit incremental cash-flow schedules** for every method.
6. Auditable Excel selection workbooks with a **validated JSON handoff** back to Python, and **rule-based selection policies** for automated runs.
7. The actual-vs-expected analysis and reserve roll-forward from December 31, 2024 to December 31, 2025, with a prior-year-development bridge.
8. Historical pseudo-year-end backtesting with a **time-to-detection** metric.
9. Method scoring against the sealed truth, and a repeated simulation study (at least 200 seeds).
10. Basic stochastic reserving: Mack, a basic ODP bootstrap, percentile ranges, and coverage checked against the truth.
11. Gross, ceded and net reserves (quota share, per-risk excess of loss, catastrophe excess of loss).
12. ALAE and ULAE (classical paid-to-paid and Kittel).
13. IFRS 17 LIC: discounting from the explicit cash flows, a confidence-level risk adjustment, and a tie-out from LIC to cash flows.
14. A simulated Appointed-Actuary-style reserve report (Tier 1 version).
15. Published-example validation tests (Friedland, Mack) and unit tests that pass in CI.
16. A one-command rebuild of the full Tier 1 pipeline.

### Tier 2: Advanced reserving research

1. **Claims-made modelling and the Professional Liability line** (the seventh line, report-year triangles).
2. Berquist-Sherman case-adequacy and disposal-rate adjustments in greater depth.
3. Venter age-to-age factor testing.
4. Brosius least-squares and credibility development.
5. Hürlimann credible loss-ratio approaches.
6. Clark curve fitting and growth-curve tail modelling.
7. Taylor and McGuire ODP / GLM calendar-year effects.
8. Shapland-style bootstrap diagnostics and adjustments.
9. Advanced credibility and mixed-model approaches.
10. Claim-level GLM / gradient-boosting models for open claims, compared with triangle methods using the truth.
11. Process-based cross-line dependence compared with a simple correlation matrix.
12. More detailed risk-adjustment methods (quantile, cost of capital, margin; Marshall et al.).
13. Layer reserving for capped and excess claims (Sahasrabuddhe), the deductible program (Siewert) and the retro premium asset (Teng and Perkins).
14. Advanced ULAE comparisons.
15. Richer claims-made modelling and a direct occurrence vs claims-made comparison.

### Tier 3: Stretch reserving research

1. Bayesian MCMC reserving (Meyers: correlated chain ladder and changing settlement rate).
2. Bayesian Bornhuetter-Ferguson (Verrall).
3. Sophisticated reinsurance reserving beyond the Tier 1 covers (Friedland 2022).
4. Quarterly close simulations (four quarter-end valuations, with actual-vs-expected and roll-forward each quarter).
5. Large-scale simulation studies with thousands of company runs, for tail analysis.
6. An interactive public page on Leo's Log built from exported JSON (hoverable triangles, selections, the reserve bridge and ranges).

### Pricing track (Exams 5, 8 and PCPA)

1. Rate indications for personal auto and homeowners (Werner and Modlin), using the selected reserving development factors.
2. A personal auto classification GLM, done as a PCPA-style project, with penalized regression and credibility-weighted territory relativities.
3. Scoring the fitted relativities and indications against the sealed true rating variables.
4. Increased limits and layer pricing for general liability from fitted severity and aggregate distributions (FFT).
5. Experience rating plans for commercial auto and general liability, and a retro plan with its insurance charges (the retro premium asset feeds back to Tier 2 reserving).
6. A pricing memo.

### Capital and ERM track (Exams 6C and 9)

1. Reinsurance pricing: exposure rating (MBBEFD) and experience rating of the per-risk layer, and the economics of the quota share.
2. A catastrophe model from the event set: AEP and OEP curves, a cat retention chosen by optimization, and a cat bond priced against the event set.
3. Risk measures (VaR, TVaR, spectral) and risk loads by line.
4. An ERM model joining reserve, premium, catastrophe and interest-rate risk, with capital allocated to the seven lines and return on allocated capital.
5. Asset-liability matching: duration matching of reserve cash flows against the bond portfolio.
6. Canadian solvency: the MCT ratio built from prescribed components (a separate regulatory exercise, not a percentile of the reserve distribution), and a financial condition test with adverse scenarios.
7. Reserve-risk-to-capital analysis: stochastic reserve risk (Tier 1 and 2) against the MCT reserve-risk charge.
8. An ERM summary and a short note on tranching (Coval, Jurek and Stafford), using the cat bond as the example.

---

## 4. Academic and exam integration

A core design rule is that the project shows how university and exam material fit together in one workflow. It keeps an explicit **method-to-course/exam map** rather than a list of unrelated topics.

### Probability and statistical foundations

Foundations are used wherever relevant: probability distributions and transformations; conditional probability and expectation; stochastic processes and Poisson processes; random variables and moments; sampling and statistical inference; estimation and maximum likelihood; hypothesis testing; regression and generalized linear modelling; matrix-based calculations; numerical optimization; simulation and Monte Carlo; time-series ideas; model diagnostics and validation.

These are not decoration. **Whenever a method is implemented, the methodology notes, code tests or report exhibits must name the mathematical idea in use.** A GLM section names the likelihood, link function, linear predictor and estimation method. A bootstrap section names the resampling mechanism and its assumptions. A Bayesian model names the prior, likelihood and posterior computation.

### Exams and what each feeds in

Every exam from P to 9 has a module. Exams 5 and 7 drive the reserving core; Exams 8 and 9 drive the extension tracks.

| Exam | What it brings | Where it lives in the project |
| --- | --- | --- |
| P | Distributions, conditional expectation, joint distributions, Poisson processes | The simulator: claim counts, sizes, report and payment lags, correlated lines |
| FM | Present values, annuities, yield curves, duration and convexity | IFRS 17 discounting; matching reserve cash flows with assets (Exam 9) |
| MAS-I | GLMs, maximum likelihood with censoring and truncation, survival models, Markov chains | Severity fits, the Taylor and McGuire GLM, claim open-to-closed transitions, the pricing GLM |
| MAS-II | Credibility, mixed models, time series, machine learning | Blending thin lines with benchmarks, forecasting inflation, flagging bad records, claim-level reserves |
| PCPA | A full GLM project: prepare, fit, validate, communicate | The personal auto classification GLM, written up as a PCPA-style project |
| Exam 5 | Reserving (Friedland, ASOP 43) and basic ratemaking (Werner and Modlin) | The deterministic reserve review, and rate indications that use its loss development |
| Exam 6C | IFRS 17, discounting, risk adjustment, MCT, financial condition testing, Appointed Actuary duties | The balance sheet, the MCT ratio, stress scenarios and the AA report |
| Exam 7 | Estimating claim liabilities, stochastic reserving, reinsurance reserving | Uncertainty, model checks and the ceded side (table below) |
| Exam 8 | Classification ratemaking, aggregate distributions, layers, experience and retro rating | Commercial and personal pricing (table below) |
| Exam 9 | Reinsurance pricing, catastrophes, risk measures, capital allocation, ERM | Capital and ERM (table below) |

### Exam 7 readings

| Reading | What you'll build | Tier |
| --- | --- | --- |
| Mack (1994), variability of chain ladder | Standard errors by accident year and in total | 1 |
| Shapland, ODP bootstrap | Bootstrap distributions (basic in Tier 1; residual diagnostics and adjustments in Tier 2) | 1 / 2 |
| Mack (2000), Benktander | Credibility-weighted method between chain ladder and Bornhuetter-Ferguson | 1 |
| Friedland (2022), reserving for reinsurance | Ceded and net reserves, quota share and excess of loss | 1 / 3 |
| Marshall et al. (2008), risk margins | Risk margins that feed the IFRS 17 risk adjustment | 1 / 2 |
| Venter (1998), testing age-to-age factors | Tests that chain ladder assumptions hold, before trusting it | 2 |
| Brosius (1993), least squares development | Least-squares and credibility development for thin lines | 2 |
| Hürlimann (2009), credible loss ratio | Loss-ratio credibility reserves as a cross-check | 2 |
| Clark (2003), LDF curve fitting | Loglogistic and Weibull growth curves, Cape Cod by maximum likelihood, tail factors | 2 |
| Taylor and McGuire, GLMs | An ODP GLM with calendar-year (inflation) effects | 2 |
| Sahasrabuddhe (2010), development by layer | Development factors for capped and excess layers | 2 |
| Siewert (1996), high deductibles | Reserving the general liability deductible program | 2 |
| Teng and Perkins (1996), retro premium | Premium asset on a small book of retro-rated commercial accounts | 2 |
| Meyers, Bayesian MCMC | Correlated chain ladder and changing settlement rate in PyMC or Stan | 3 |
| Verrall (2007), predictive distributions | Bayesian Bornhuetter-Ferguson with judgment built into the priors | 3 |

### Exam 8 readings (Pricing track)

| Reading | What you'll build |
| --- | --- |
| Goldburd et al., GLMs for insurance rating | Frequency and severity GLMs for personal auto, with offsets, interactions and lift charts |
| Chalk et al., from GLMs to comprehensive pricing | Combining the GLMs with territory, expense and other components into one rating plan |
| Holmes and Casotto, penalized regression | Lasso and ridge for high-dimensional variables such as vehicle model and postal code |
| Couret and Venter; Mahler; Bailey and Simon | Credibility for class and territory relativities, and for risk parameters that shift over time |
| ASOP 12 and ASOP 25 | Checks that classes are valid and credibility is applied properly |
| Bahnemann, distributions for actuaries | Aggregate loss distributions by FFT, and expected cost by layer |
| Fisher et al., individual risk rating | An experience rating plan for commercial auto, and a retro plan with its insurance charges |
| ISO CGL experience rating plan | An experience rating plan for general liability |

### Exam 9 readings (Capital and ERM track)

| Reading | What you'll build |
| --- | --- |
| Clark (2014), basics of reinsurance pricing | Pricing the quota share, per-risk and catastrophe covers that the reserving part cedes to |
| Bernegger (1997), MBBEFD exposure curves | Exposure rating the commercial property per-risk excess of loss |
| Grossi and Kunreuther, catastrophe modelling | A simple cat model: an event set, damage functions, and AEP and OEP curves |
| Cummins (2008), cat bonds | A cat bond on the homeowners book, priced against the event set |
| Mildenhall and Major, pricing insurance risk | Risk measures (VaR, TVaR, spectral) and risk loads by line |
| Cummins (2000), capital allocation | Capital allocated to the seven lines, and return on allocated capital |
| Brehm et al., enterprise risk analysis | An ERM model joining reserve risk, premium risk, catastrophes and interest rates |
| Panning (2006), interest rate risk | Duration matching of the reserve cash flows against a bond portfolio |
| Coval, Jurek and Stafford, structured finance | A short note on tranching, using the cat bond as the example |

### University courses

Every math, statistics and computer science course has a job. A few pure-math courses touch the project lightly, and the table says so rather than forcing them.

| UTSC course | What it brings | Where it's used |
| --- | --- | --- |
| CSCA08 Intro to Computer Science I | Python and program design | The whole codebase |
| CSCA67 Discrete Mathematics | Logic, sets, counting, graphs | Data validation rules, reconciliation, the claim-state graph |
| MATA22, MATB24 Linear Algebra I and II | Matrices, least squares, eigenvalues, positive definiteness | GLM and least-squares fits (Brosius), PCA of patterns, Cholesky for correlated lines |
| MATA31, MATA37 Calculus I and II | Integrals and series | Limited expected values, increased limits factors, tail factors as infinite products |
| MATB41, MATB42 Several-variable calculus | Gradients, Hessians, change of variables | Maximum likelihood (Clark), parameter variance from the Hessian, copulas |
| MATB43 Introduction to Analysis | Limits and convergence | When tail factors converge; convergence of bootstrap and MCMC estimates |
| MATB44, MATC46 Differential Equations I and II | ODEs and their solutions | Interest rate models (Vasicek) for discount curves; growth curves for development |
| MATB61 Linear Programming and Optimization | Linear programs, constraints, duality | Choosing reinsurance retentions and the capital mix under constraints |
| MATC34, MATD34 Complex Variables I and II | Complex functions, contour integrals, transforms | Characteristic functions and FFT for aggregate loss distributions |
| MATC01, MATD01 Groups and Symmetry; Fields and Groups | Groups and finite fields | Light: the permutation symmetry behind bootstrap resampling, and the finite-field maths inside random number generators |
| MATC63 Differential Geometry | Curves and curvature | Light: curvature penalties when smoothing development and yield curves |
| STAB52 Probability, STAC62 Stochastic Processes I | Distributions, Poisson processes, Markov chains | The simulator and the claim-state transitions |
| STAB57 Statistics, STAC58 Statistical Inference | Estimation, likelihood ratio tests, Bayesian inference | Fitting and testing every model; the priors in Verrall and Meyers |
| STAC51 Categorical Data Analysis | Logistic and Poisson regression | Closed-without-payment and reopen probabilities; claim counts |
| STAC67 Regression Analysis | Regression and its diagnostics | Venter's tests and residual checks |
| STAD37 Multivariate Analysis | Covariance, PCA, multivariate distributions | Correlation between lines and adding up the reserve distribution |
| CSCC37 Numerical Algorithms | Root finding, integration, interpolation, stability | Likelihood solvers, yield-curve interpolation, FFT accuracy |

---

## 5. Simulator design

The simulator is the foundation of the project. It is designed independently of the methods it will later test.

### Core principle

> **Simulate the underlying claim process, not the triangles.**

The simulator must never generate development factors and then reverse-engineer claims to match them. Triangles must emerge from claim arrivals, reporting, settlement, case reserving and payments.

Claims are generated one at a time, and every payment and reserve change is its own transaction.

### Calibration and realism: Schedule P as an acceptance target, not an input

The CAS loss reserving dataset (NAIC Schedule P) is public, but it holds **aggregate US triangles by company and line**. It has no claim-level lags or severities, no Canadian or Ontario benefit structure, and no separate physical-damage line. It therefore cannot supply claim-level parameters, and tuning inputs until emergent factors match would drift toward reverse-engineering triangles. So:

1. **Inputs** (arrival rates, lognormal bodies, Pareto tails, reporting and payment lags, case-reserve behaviour) are set from first principles and published industry sources, and recorded in `config/`.
2. **Acceptance targets** come from Schedule P. Simulated triangles, aggregated from the claim process, must fall inside configured bands on: paid and reported development patterns by closest-matching line; paid-to-ultimate patterns; loss-ratio levels and the cross-company dispersion of ultimate loss ratios; and the coefficient of variation of reserves. Mapping: personal auto to the two personal auto lines (shape only), commercial auto to commercial auto, other liability to CGL, homeowners to homeowners, special property to commercial property.
3. Where a line has no Schedule P analogue (Ontario accident benefits, claims-made professional liability), the target is a documented judgment range with a stated source, and the exhibit says so.
4. **The build fails** when a generated company falls outside the configured bands (section 18).

### Claim generation sequence

1. **Policies and exposure.** Written and earned premium by month; policy counts and exposure; limits and deductibles; a rate-change history for on-levelling. Each policy carries rating variables (driver age, territory, vehicle, construction, limit) that truly drive its frequency and severity, so the pricing GLM has a sealed truth too.
2. **Claim arrivals.** Poisson or related count processes; seasonality (winter collisions, summer hail); a frequency trend; line-specific behaviour; a 2020 drop in auto frequency.
3. **Severity.** Lognormal bodies with Pareto tails by coverage; severity trended by an inflation index that spikes in 2021 to 2023; limits and deductibles applied; separate large-loss behaviour.
4. **Reporting lag.** Days to months for property, years for liability. Professional liability follows a claims-made reporting process and is triangulated by report year.
5. **Claim lifecycle.** Each claim opens, gets an initial case reserve from information available at reporting, has the reserve revised, is paid in parts, and closes. Some close without payment; some reopen. ALAE, salvage and subrogation flow on the same claim.
6. **Catastrophes and large losses.** A 10,000-year catalogue of hail, flood and wind events; the two or three that actually occur are drawn from it and coded CAT. Large individual losses and large-loss frequency shocks test capping and excess layers. Events create correlation across affected lines.
7. **Reinsurance.** A 30% quota share on commercial property; $2M xs $1M per-risk excess of loss; a catastrophe excess of loss; recoveries that arrive late; gross, ceded and net transaction views.
8. **Economic scenarios.** Interest-rate and inflation paths from a simple Vasicek model, for discounting, asset-liability matching and stress tests. These are also shared latent drivers (section 16).
9. **Assets.** A simple bond portfolio backing the reserves, for the MCT and the interest-rate work.
10. **Sealed truth.** True ultimate by claim; true ultimate by coverage, line, accident/report year and insurer; true rating relativities by policy; future development retained but unavailable until the appropriate valuation date.

### Case-reserve process

Case reserves must not be a fixed percentage of true ultimate. Initial and later case estimates carry realistic uncertainty and systematic effects, so case adequacy is itself part of the reserving problem. Modelled effects include: severity information learned over time; litigation or complexity indicators; claim age; claims-handler bias; systematic strengthening or weakening; settlement-rate changes; and reopening.

---

## 6. Hidden structural changes

Some generation parameters are hidden from the analyst. These events test whether methods detect or respond to assumption violations.

- Case reserves strengthened in 2021 for general liability (Berquist-Sherman case adequacy).
- A new claims system in 2019 that accelerates settlement (Berquist-Sherman disposal rate).
- An Ontario accident-benefit reform affecting accident years from about mid-2016, modelled on the 2016 reform.
- Calendar-year inflation from 2021 to 2023 that chain ladder cannot see (Taylor and McGuire calendar effects).
- A line-of-business recode during the 2019 system migration.
- Changes in severity trend.
- Changes in claims reporting behaviour.
- CAT years.
- Large-loss frequency shocks.

### Anti-hindsight design

The presence, magnitude and timing of some structural changes are randomized from plausible ranges using the simulation seed. The analyst receives only observable data and documented business information. The generator writes a **hidden scenario log** to a separate location that is opened only by the scoring pipeline. This turns the simulator into a controlled experiment rather than a known-answer exercise.

Each planted change is recorded with a start date, affected lines and cohorts, and a magnitude. The time-to-detection metric (section 9, Stage 7) is computed against this log.

---

## 7. Mess-to-plant data-quality layer

Raw data intentionally contain realistic problems:

- duplicate transactions;
- report dates before accident dates;
- missing or invalid line-of-business codes;
- recoveries entered as positive payments;
- claims booked to the wrong accident year;
- zero-dollar claims;
- missing CAT codes on some event claims;
- paid and case totals that do not reconcile to the financial statements until fixed.

The cleaning process must, for each issue: detect it; document the resolution rule; record the number and dollar value of affected records; reconcile to control totals; and calculate the reserve impact.

### Required exhibit: the data-quality bridge

| Stage | Selected ultimate |
| --- | ---: |
| Raw data | $X |
| After duplicate removal | $X |
| After accident-year corrections | $X |
| After recovery corrections | $X |
| After CAT-code and line-code corrections | $X |
| Final clean data | $X |

Because the true ultimate is sealed, the bridge can later be scored too: each cleaning step should move the estimate toward the truth, and any step that does not is a finding.

---

## 8. Data architecture

All raw and processed data are stored as Parquet with a fixed random seed and a configuration file, so the company rebuilds exactly. **All money is held as integer cents**, so reconciliation checks are exact rather than approximate.

The distinction between policy/exposure data, claim attributes and transaction ledgers is permanent, even if exact schemas evolve.

**Canonical claim table**

```text
claim_id, policy_id, line, coverage
accident_date, report_date, close_date, reopen_date
accident_year, report_year, policy_year
CAT_event_id, large_loss_flag, loss_component   # attritional | large | cat
limit, deductible
true_ultimate                                   # sealed; separate dataset
```

**Claim transaction table**

```text
claim_id, transaction_id, transaction_date, transaction_type
paid_loss, case_reserve, ALAE, salvage, subrogation, ceded_amount
```

**Policy / exposure table**

```text
policy_id, policy_year, line, coverage
written_premium, earned_premium, exposure, limit, deductible, rate_change
rating variables (driver age, territory, vehicle, construction, ...)
true relativities                               # sealed; separate dataset
```

Claims-made policies additionally keep effective and expiry dates, retroactive date, and report-year fields (Tier 2).

---

## 9. Reserving workflow

The review follows a real year-end close, with a separate research layer. Each stage ends in a file the next stage reads.

### Stage 1: Data intake and raw reconciliation (Python)

- Load raw transactions; preserve raw data unchanged.
- Reconcile paid, case and ceded totals to financial-statement control totals.
- **Guardrail G1a (raw):** every dollar of difference between the raw ledger and the control totals must be explained by a logged issue. Unexplained difference fails the stage.
- Produce a data-quality log in the spirit of ASOP 23.

### Stage 2: Cleaning, segmentation and component guardrail (Python)

- Detect and repair planted errors; document every correction.
- Segment into homogeneous groups (line by coverage); identify CAT and large-loss components; create full, attritional and large/CAT views.
- **Guardrail G1b (clean):** `Sum(Attritional) + Sum(Large) + Sum(CAT)` must equal the clean ledger total, which must equal the control totals adjusted for documented corrections, **exactly, in integer cents**. This check sits here, after cleaning, because the raw data are deliberately wrong and the component labels (including missing CAT codes) are not reliable until Stage 2 has run.
- The pipeline halts if G1b fails; no triangle is built from unreconciled data.

### Stage 3: Triangle generation (Python, exported to Excel)

Paid, incurred, reported counts, closed counts, closed-without-payment, ALAE, salvage/subrogation, gross/ceded/net; paid-to-incurred, closure-rate, average case and average paid diagnostics. Accident year for occurrence lines, report year for claims-made, annual and quarterly where applicable.

- **Guardrail G1c (triangles):** the latest diagonal of every triangle ties to the clean ledger, and cumulative-to-incremental conversion round-trips exactly.

### Stage 4: Deterministic point estimates (Python engine)

At minimum: paid and incurred chain ladder; expected claims; Bornhuetter-Ferguson; Cape Cod; Benktander; frequency-severity; case outstanding development; Berquist-Sherman case-adequacy and disposal-rate adjustments; tail factors. Tier 2 adds alternative development and curve-fitting methods.

**Cash-flow requirement.** Every method outputs an explicit incremental future cash-flow schedule, so IFRS 17 discounting never has to reverse-engineer a payment pattern. The schedule is keyed by method, line, segment, accident/report year, payment calendar period, component (loss, ALAE, ULAE, salvage/subrogation) and basis (gross, ceded, net). Two tests are mandatory:

1. For each accident year, the schedule sums to selected ultimate minus paid to date.
2. Ceded plus net equals gross in every cell.

The payment-timing convention (for example mid-period) is declared in `config/`.

### Stage 5: Selections (Excel judgment layer, validated JSON handoff)

For each line and valuation date, Python writes a workbook with live formulas: all-year averages, latest 3 and 5, volume-weighted, high/low exclusions, alternative tails, selected age-to-age factors, selected ultimate by accident/report year, written rationale for every judgment call, and selected IBNR.

**Handoff rules:**

1. Selections live in **named Excel Tables** with fixed column headers. Python reads them **by table and header name**; hardcoded `openpyxl` cell coordinates are forbidden, so inserting a row or reformatting a sheet cannot break the pipeline.
2. Python validates the extracted selections against a schema (for example `jsonschema` or `pydantic`): every age has a factor, every accident year has an ultimate and a rationale, and the basis is one of the allowed values.
3. Validated selections are written to `selections/frozen/<line>_<valuation_date>.json` with a SHA-256 hash and timestamp. All later stages read **only the frozen JSON**.
4. A frozen file's hash is recorded before the truth is unsealed.

**Selection policies for automated runs.** A human cannot pick factors for 200 seeds or dozens of backtest dates. So the project defines rule-based policies, run by the same engine: P0 all-year volume-weighted; P1 latest 3; P2 latest 5; P3 excluding high and low; P4 diagnostic-adaptive (switches basis when a Venter test or a calendar-year residual flags). The **human workbook** is used for the primary 2024 and 2025 reviews only. Comparing the human selections with the policies, scored against the truth, answers research question 11.

### Stage 6: Actual vs expected and roll-forward (Python and Excel)

Compare 2025 emergence with what the 2024 review expected. Split the movement into prior-year development; explain each strengthening or release; show the movement as a bridge from the December 31, 2024 reserve to the December 31, 2025 reserve. The 2024 selection is frozen before any 2025 information is exposed.

### Stage 7: Historical backtesting and scoring

For multiple historical valuation dates (annual, and semi-annual or quarterly where data allow):

1. Truncate the dataset as if the valuation date were current.
2. Run the reserving process using only information available then.
3. Freeze the selection.
4. Reveal later development and calculate the actual ultimate error against the truth.
5. Score every method and policy (section 15).

**Time-to-detection.** For each planted shock in the hidden log, and each method or policy, take the cohorts the shock affects and compute the relative error `e_v = (selected ultimate - true ultimate) / true ultimate` at each valuation `v` after the shock begins. The detection time is the number of valuation periods until `|e_v| <= tau` and stays within `tau` for the next two valuations (default `tau` = 5% of ultimate, configurable; both `tau` and the valuation frequency are reported in every exhibit). A method that never gets there is recorded as censored, not dropped. A second, signal-based version records the first valuation at which a diagnostic (Venter test, calendar-year residual, closure-rate or case-adequacy diagnostic) flags the shock. The gap between the two is itself a finding.

The principal output is the **method failure map** (section 17).

### Stage 8: Stochastic reserving

- **Tier 1:** Mack standard errors; basic ODP bootstrap; reserve distributions; percentile ranges; coverage validated against the sealed truth.
- **Tier 2:** Venter testing; Shapland-style bootstrap diagnostics and adjustments; Clark / ODP methods; Taylor and McGuire calendar-year GLM; credibility-based stochastic alternatives. Lines are combined into a total with a correlation assumption, and later compared with process-based dependence (section 16).
- **Tier 3:** Meyers-style correlated chain ladder and changing settlement rate; Bayesian MCMC; Bayesian Bornhuetter-Ferguson.

### Stage 9: Reinsurance and layers

- **Tier 1:** gross, ceded and net reserves; quota share; per-risk excess of loss; catastrophe excess of loss; recovery timing; reconciliation of gross and net cash flows.
- **Tier 2:** capped and excess-layer development (Sahasrabuddhe); the general liability deductible program (Siewert); the retro premium asset (Teng and Perkins).
- **Tier 3:** advanced reinsurance reserving (Friedland 2022).

### Stage 10: Expenses

ALAE analysed alongside losses; ULAE by classical paid-to-paid and Kittel methods (Tier 1); comparison of alternative allocation assumptions (Tier 2).

### Stage 11: IFRS 17 LIC and discounting

Scope is the **Liability for Incurred Claims**, not a full contract-grouping or CSM build. Components: expected future cash flows (taken directly from the Stage 4 schedules); payment timing; discounting on a yield curve (Vasicek-based scenarios); a risk adjustment; gross and reinsurance-held views.

**Tie-out test:** undiscounted LIC equals the sum of the cash-flow schedule; discounted LIC equals the schedule discounted on the stated curve; the difference is the discount, which is reported.

The risk adjustment is not equated with one arbitrary percentile. Tier 1 uses a stated confidence level taken from Stage 8. Tier 2 compares confidence-level, cost-of-capital and margin approaches (Marshall et al.) and reports the implied confidence levels and sensitivities.

### Stage 12: Report

A simulated year-end actuarial reserve review: executive summary; reserve selections; prior-year development and actual-vs-expected; reserve movement bridge; method comparison; uncertainty ranges; gross/ceded/net; IFRS 17 LIC exhibits; assumptions and limitations; a simulated Appointed-Actuary-style conclusion; methodology and reproducibility appendices. It must state that it is a **fictional, simulated actuarial exercise**, not a signed professional opinion.

The **Tier 1 report** covers six lines and ends the Core release. Tier 2 adds Professional Liability as an addendum and updates the totals; it does not reopen the Tier 1 report.

---

## 10. Large-loss, catastrophe and attritional structure

The reserve process must not remove the hard claims and reserve only the remainder. The analysis distinguishes:

1. **Full booked loss:** everything reported and transacted.
2. **Attritional / capped loss:** the stable base for development methods.
3. **Large-loss component:** a separately modelled component for large individual claims.
4. **CAT component:** a separately modelled event-driven component.

The selected reserve reconciles these components (guardrail G1b) rather than silently discarding volatility.

---

## 11. Claims-made modelling (Tier 2)

Professional liability is modelled as genuinely claims-made business, not an accident-year triangle with a different label. The data model retains policy effective and expiry dates, retroactive date, policy year, report date, reporting lag, limits and deductibles, discovery or notification information, and report-year development. The project compares occurrence and claims-made behaviour under different development assumptions. The data model supports this from Phase 1 so that switching the line on in Tier 2 requires no schema change.

---

## 12. Pricing track (Exams 5, 8 and PCPA)

Pricing takes the reserve review's output and keeps going, on the same carrier and data.

1. **Rate indications** for personal auto and homeowners: on-level premium, trend losses, develop them with the selected reserving factors, apply credibility, and produce the indicated change (Werner and Modlin).
2. **A classification GLM** for personal auto as a PCPA-style project: frequency and severity GLMs; penalized regression for high-dimensional variables; credibility-weighted territory relativities; validation with lift charts and out-of-sample tests; then **scoring the fitted relativities against the sealed truth**.
3. **Increased limits and layers** for general liability from fitted severity distributions and aggregate distributions by FFT.
4. **Experience and retro rating** for commercial auto and general liability. The retro plan's premium asset feeds back into reserving (Teng and Perkins).
5. **Pricing memo** documenting indications, selections and the standards used (ASOP 12 and 25).

Gates are in section 23. Because the truth is sealed, each pricing result can be scored: relativity error, lift versus truth, and the indication error caused by reserving error in the loss development.

---

## 13. Capital and ERM track (Exams 6C and 9)

1. **Reinsurance pricing.** Exposure-rate (MBBEFD) and experience-rate the per-risk layer; examine the quota share's economics.
2. **Catastrophes.** Build AEP and OEP curves from the event set; choose the cat retention by optimization; price a cat bond on the homeowners book against the event set.
3. **Risk measures and loads.** VaR, TVaR and spectral measures; risk loads and capital by line.
4. **ERM model.** Join reserve risk (from Tiers 1 and 2), premium risk, catastrophe risk and interest-rate risk; allocate capital to lines; report return on allocated capital.
5. **Asset-liability matching.** Duration-match the reserve cash flows (from Stage 4) against the bond portfolio.
6. **Canadian solvency.** MCT is a **separate regulatory exercise** with prescribed insurance-risk components, other components, diversification and ratio mechanics. It is not the 99th or 99.5th percentile of the reserve distribution. Add a financial condition test with adverse scenarios and the Appointed Actuary's opinion framing.
7. **Reserve-risk-to-capital.** Compare internal stochastic reserve risk with the MCT reserve-risk charge.
8. **ERM summary** and a short note on tranching using the cat bond.

The simple cat model is a teaching model, not a vendor model, and the ERM write-up says so.

---

## 14. Method engine architecture

Python does the computation; Excel holds the judgment layer.

| Job | Tool | Why |
| --- | --- | --- |
| Simulating, cleaning and reconciling 10M+ rows | Python (Polars or DuckDB on Parquet) | Excel stops at 1,048,576 rows |
| Triangles and method engine | Python (pandas and own code) | Repeatable across lines and valuation dates |
| Cross-check of the engine | [chainladder-python](https://github.com/casact/chainladder-python) | Mack, bootstrap and Clark should match it |
| Factor and ultimate selections | Excel, written with openpyxl or xlsxwriter | Judgment with auditable formulas |
| Selection handoff | Named Excel Tables, schema validation, frozen JSON | Pipeline cannot break on formatting |
| GLMs and claim-level models | statsmodels, scikit-learn | Taylor and McGuire; pricing GLM; claim-level models |
| Bayesian models | PyMC or Stan | Meyers and Verrall (Tier 3) |
| Optimization and aggregation | SciPy, NumPy FFT | Retentions, aggregate distributions |
| Diagnostics and reporting | Jupyter, then Markdown or PDF | One rebuild produces every exhibit |

The Python and Excel workflow is a true round trip:

```text
Python data + method engine
        ↓
Excel selection workbook (named Tables, live formulas)
        ↓
human selections + rationale
        ↓
Python extracts by header name, validates schema
        ↓
frozen JSON (hash + timestamp)
        ↓
final reserve / stochastic / report outputs
```

---

## 15. Truth, scoring and research framework

This is what turns the project from an implementation exercise into research.

### Sealed truth

Every claim has a simulated true ultimate, and every policy has true rating relativities. They sit in separate datasets and are exposed only to the scoring pipeline after selections are frozen.

### Method scoring

For each method (and selection policy) and line: bias; mean absolute error; root mean squared error; percentage error; signed reserve error; over/under-reserving frequency; ranking by scenario; reserve volatility across simulations; time-to-detection. The same machinery scores pricing results (relativity error, lift versus truth, indication error).

### Stochastic calibration

Interval coverage; probability that the realized ultimate falls inside the stated range; average interval width; bias of central estimates; tail calibration.

### Two kinds of simulation study

- **Method research:** at least 200 company simulations with different seeds, to compare methods, biases and coverage. This is Tier 1.
- **Tail estimation:** very high percentiles need far more runs (thousands or more); a few hundred cannot estimate extreme tails. This is Tier 3.

Every exhibit states the number of seeds and the confidence in the estimate (for example, the standard error of an estimated coverage rate).

---

## 16. Process-based dependence across lines

The company-level distribution is studied two ways.

1. **Simple approach:** aggregate line-level reserve distributions with an assumed correlation matrix.
2. **Process-based approach:** introduce shared latent drivers into the simulator: inflation and interest rates (the Vasicek paths), economic conditions, claims-severity trend, the legal and regulatory environment, the catastrophe environment, and the claims-handling environment. Lines respond differently to each driver.

The comparison is **assumed correlation versus correlation produced by a common underlying claims process.** The sensitivity of total reserve percentiles to the dependence assumption is reported (Tier 2), and the same drivers feed the ERM model (Capital track).

---

## 17. Backtesting framework and the method failure map

Historical pseudo-valuations follow: observed information at the valuation date, then reserve selection, then frozen prediction, then future development, then actual ultimate, then scoring. Backtests cover multiple accident/report years and lines where data are sufficient.

The principal output is a **method failure map**, with results filled in by simulation rather than chosen in advance:

| Scenario | Chain Ladder | BF | Cape Cod | Bootstrap | Bayesian |
| --- | --- | --- | --- | --- | --- |
| Stable process | ? | ? | ? | ? | ? |
| Inflation shock | ? | ? | ? | ? | ? |
| Case strengthening | ? | ? | ? | ? | ? |
| Disposal-rate change | ? | ? | ? | ? | ? |
| Thin data | ? | ? | ? | ? | ? |
| CAT year | ? | ? | ? | ? | ? |

Each cell reports bias, error and time-to-detection, not just a pass/fail mark.

---

## 18. Validation and testing

No method is trusted because its output looks plausible.

**Mathematical / textbook validation.** Reproduce published examples to the dollar and automate them: Friedland's worked examples, the numbers in Mack's paper, Shapland's examples, and other examples from the Exam 7 material. Pricing and capital modules reproduce their published examples the same way.

**Software validation.** Unit tests cover triangle construction; cumulative-to-incremental conversion; age-to-age and tail factors; reserve calculations; stochastic simulation logic; reinsurance layer calculations; cash-flow schedules (sum and gross = ceded + net); discounting and the LIC tie-out; reconciliation guardrails G1a, G1b and G1c.

**Simulation validation.** Acceptance criteria exist for frequency, severity, loss ratio, reporting lag, payment lag, closure rate, case-reserve behaviour, development-factor distributions, CAT frequency, large-loss frequency, premium growth, and trend and inflation, including the Schedule P bands in section 5. **The build fails** when a generated company falls materially outside the configured realism ranges.

---

## 19. Reproducibility and information barriers

The project behaves as though the analyst cannot see the future.

- **2024 valuation:** frozen before any 2025 information is exposed.
- **Truth:** a separate sealed dataset, exposed only to scoring after selections are locked.
- **Scenarios:** the hidden scenario log stays outside the analysis environment.
- **Rebuild:** a single command performs, in order: generate the company; generate raw transactions; apply the data-quality layer; clean and reconcile (G1a, G1b); build triangles (G1c); run methods and write cash flows; produce selection workbooks; import frozen selections; run stochastic analysis; produce report exhibits; run truth-based scoring. Tier 1 ships with this command; later tiers and tracks extend it.

---

## 20. Repository structure

```text
granite-reserving/
├── config/              # YAML: segments, caps, tail choices, correlation, tolerances, seeds
├── simulate/            # company generator, event catalogue, economic scenarios; sealed truth
├── data/                # raw/, clean/, triangles/ as Parquet (git-ignored; rebuilt from seed)
├── reserving/           # methods/, stochastic/, reinsurance/, ifrs17/, cashflows/
├── pricing/             # indications, GLM, layers, rating plans
├── capital/             # cat model, reinsurance pricing, ERM, MCT
├── selections/          # workbooks per line / valuation date; frozen/ JSON
├── backtest/            # pseudo-valuations, scoring, time-to-detection, failure map
├── validation/          # textbook examples and model tests
├── notebooks/           # exploration and diagnostics
├── report/              # reserve report, pricing memo, ERM summary
├── web/                 # public interactive outputs, if built
└── docs/                # scope, methodology and research notes
```

Large generated datasets are not committed. The repository holds code, configuration, small representative test data and instructions sufficient to rebuild everything.

---

## 21. Deliverables

**A. Data system:** raw warehouse; clean warehouse; reconciliation report (G1a to G1c); data-quality log and bridge; schemas.
**B. Triangle library:** paid, incurred, counts, ALAE, salvage/subrogation, gross/ceded/net; occurrence and claims-made variants.
**C. Method engine:** deterministic and stochastic methods; cash-flow schedules; diagnostics; tests; external cross-checks.
**D. Selection workbooks and frozen JSON:** one auditable workbook per line and valuation date.
**E. Research outputs:** method scorecards; backtesting results; time-to-detection tables; method failure map; stochastic coverage analysis; human-vs-policy comparison; sensitivity and dependence analysis; data-cleaning impact study.
**F. Financial and actuarial outputs:** reserve summary; gross/ceded/net; ALAE/ULAE; IFRS 17 LIC and risk adjustment analysis.
**G. Reserve report:** executive summary; selections; prior-year development; actual-vs-expected; methodology; assumptions; stochastic ranges; reinsurance; IFRS 17; limitations; methodology appendix; research findings.
**H. Pricing outputs (Pricing track):** indications, GLM project write-up, layer and rating plans, pricing memo.
**I. Capital outputs (Capital track):** reinsurance and cat studies, ERM model and summary, MCT and financial condition test.
**J. Public write-up:** a companion project page on **Leo's Log** ("The Big One") covering motivation, architecture, methodology, selected charts, method comparisons, key findings and lessons.

---

## 22. Limitations

The project is a simulation and cannot reproduce every aspect of real claims handling. The biggest risk is **circularity**: if the simulator works the way chain ladder assumes, chain ladder will look perfect and the project proves nothing. The defences are built into the design: simulate claim processes, not development factors; plant changes the methods must detect; randomize some parameters from ranges; keep the truth sealed.

| Limitation | Effect | Mitigation |
| --- | --- | --- |
| You write the simulator and do the analysis | You know where the planted changes are | Randomized hidden scenarios; seed and log hidden until scoring |
| Simulated behaviour is simpler than real people | No real case-reserving philosophy, litigation or social inflation | Schedule P acceptance bands; document stylized assumptions |
| Schedule P is aggregate US data | It cannot calibrate claim-level parameters or Canadian features | Use it only as an acceptance target; label judgment ranges where no analogue exists |
| Human selections do not scale | Cannot be run for hundreds of seeds | Rule-based selection policies; human workbook for the primary review only |
| Canada does not fit every reading | Workers' comp is provincial; retro rating and large-deductible programs are rare | Keep Siewert, Teng and Perkins and the retro plan as a small, labelled commercial book |
| Exams not yet studied | 6C, 7, 8 and 9 come later; modules risk resting on a shallow reading | Build each module while studying for that exam |
| Pure-math courses | Groups, fields and differential geometry touch the work lightly | Keep those uses small and honest |
| A simple cat model | A 10,000-year event set is not a vendor model | Treat it as a teaching model and say so |
| Excel's size limit | 1,048,576 rows | Excel only ever sees triangles and summaries |
| 10M+ transaction scale | Large files are expensive to process | Parquet, Polars or DuckDB, summarized Excel outputs |
| Long-tail data window | Too few mature years for some tail experiments | Generate extra pre-2011 history |
| Bayesian methods are expensive | Full-company MCMC is impractical | Run on selected lines and scenarios (Tier 3) |
| Cross-line dependence is hard to infer from 15 years | Aggregation assumptions can dominate tail results | Compare simple correlation with process-based dependence; show sensitivity |
| Scope | Reserving, pricing and capital is several years of evenings | Ship in tiers and phases; each is useful alone; stretch a phase rather than weaken its gate |
| No reviewer | Nobody checks your judgment | Self-review against ASOP 43 and CIA standards; ask an FCAS at work to read the report |
| Real company data cannot be used | The portfolio cannot claim to reproduce a real insurer | Keep everything fictional and say so on the site |

---

## 23. Phased plan (vertical slice first)

The plan starts after the **MAS-I sitting on October 28, 2026**. The architecture is secured end to end on one line before it expands. The schedule is a target; each phase has an independent pass/fail gate. If an exam sitting or work responsibility conflicts, **stretch the phase rather than weaken its gate.**

| Phase | When | What | Gate to move on |
| --- | --- | --- | --- |
| **1. Vertical slice (Personal Auto PD)** | Nov 2026 | The full pipeline for one short-tail line: simulation (claims-made-ready schema), G1 guardrails, triangles, chain ladder / BF / Cape Cod, cash-flow export, Excel to frozen-JSON handoff, scoring against truth | One command runs from seed to truth-scored ultimate; G1a to G1c pass; Schedule P acceptance bands pass; Excel round trip survives an inserted row |
| **2. Simulator and data expansion** | Dec 2026 to Jan 2027 | The other five occurrence lines; hidden scenarios; the data-quality layer; cleaning, segmentation and the full triangle library | Every planted data issue is found, logged and quantified; data-quality bridge produced; G1 passes for all lines |
| **3. Point estimates and roll-forward** | Feb to Mar 2027 | Exam 5 methods including both Berquist-Sherman adjustments; Excel selections; actual-vs-expected and the 2024 to 2025 roll-forward | Friedland's worked examples pass as tests; cash flows tie to unpaid; a one-page memo on the reserve movement |
| **4. Backtesting and scoring** | Apr to May 2027 | Historical pseudo-valuations; selection policies P0 to P4; time-to-detection; 200-seed study; method failure map v1 | Frozen historical selections score correctly against later truth; human-vs-policy comparison produced |
| **5. Stochastic (Tier 1)** | Jun to Jul 2027 | Mack, basic bootstrap, ranges; coverage against truth | Mack and bootstrap match chainladder-python; coverage table produced |
| **6. Ceded, expenses, IFRS 17 and report: Core release** | Aug to Sep 2027 | Reinsurance, ALAE/ULAE, discounting, risk adjustment, the Tier 1 report | LIC ties to cash flows; the report reconciles; one-command rebuild works; the truth is then unsealed and scored |
| **7. Tier 2 and 3 reserving research** | Oct 2027 onward | Claims-made PL switched on; Tier 2 methods in value order; selected Tier 3 work; report addendum | Each method has a validation test and a scorecard; PL reconciles; dependence comparison produced |
| **8. Pricing** | While studying Exam 8 | Indications, classification GLM, layers, rating plans, pricing memo | Fitted relativities are close to the sealed truth; indications reconcile to the reserving development |
| **9. Capital and ERM** | While studying Exam 9 | Reinsurance pricing, cat model, ERM, MCT and financial condition test | Capital adds up by line; cat curves match the event set; MCT mechanics reconcile |

The earlier eight-phase roadmap image needs updating to these nine phases.

---

## 24. Final research product

The project should answer more than "what reserve did Granite Lantern hold at December 31, 2025?" It should answer:

> **"Given the actual simulated claims process, which methods were accurate, which were robust, which assumptions were violated, how quickly did the methods detect those changes, and how reliable were their stated uncertainty ranges?"**

and, through the extension tracks, how those answers carry into prices and capital.

The research package contains: a reserve report; a technical repository; a simulation study; a backtesting framework; a method failure map; a pricing and capital package; a mathematical appendix; and a reproducibility package.

The strongest possible conclusion is not that one method is universally best. It is that:

> **different methods succeed or fail for identifiable reasons tied to the underlying claims process, and actuarial judgment consists partly of recognizing which assumptions are currently plausible.**

---

## 25. Sources

- [CAS Exam 7 content outline, Fall 2026](https://www.casact.org/sites/default/files/2026-03/Exam_7_CO_2026_Fall.pdf)
- [CAS Exam 8, Advanced Ratemaking](https://www.casact.org/exam/exam-8-advanced-ratemaking)
- [CAS Exam 9, Risk Management for Actuaries](https://www.casact.org/exam/exam-9-risk-management-actuaries)
- [CAS Exam 5 content outline, Fall 2026](https://www.casact.org/sites/default/files/2026-03/Exam_5_CO_2026_Fall.pdf)
- [CAS Exam 6C content outline, Fall 2026](https://www.casact.org/sites/default/files/2026-03/Exam_6C_CO_2026_Fall.pdf)
- [CAS exam pathway 2026](https://actuary.info/insights/cas-exam-pathway-2026-complete-guide)
- [MAS-I study guide 2026](https://freefellow.org/blog/cas-mas-i-study-guide-2026/) and [MAS-II study guide 2026](https://freefellow.org/blog/cas-mas-ii-study-guide-2026/)
- [CAS loss reserving data from NAIC Schedule P](https://www.casact.org/publications-research/research/research-resources/loss-reserving-data-pulled-naic-schedule-p)
- [chainladder-python](https://github.com/casact/chainladder-python)
- Friedland, *Estimating Unpaid Claims Using Basic Techniques*; Friedland (2022), reserving for reinsurance
- Mack (1994); Mack (2000); Venter (1998); Brosius (1993); Hürlimann (2009); Clark (2003); Shapland, ODP bootstrap; Meyers, Bayesian and correlated reserving; Verrall (2007); Taylor and McGuire; Marshall et al. (2008); Sahasrabuddhe (2010); Siewert (1996); Teng and Perkins (1996)
- Werner and Modlin; Goldburd et al.; Chalk et al.; Holmes and Casotto; Bahnemann; Fisher et al.
- Clark (2014); Bernegger (1997); Grossi and Kunreuther; Cummins (2000, 2008); Mildenhall and Major; Brehm et al.; Panning (2006); Coval, Jurek and Stafford

Where a professional standard or regulatory framework is referenced, use the version applicable when the relevant phase is completed and record its effective date in the methodology notes.

---

## 26. One-sentence project definition

> **Granite Reserving is a reproducible simulated Canadian P&C insurer that uses claim-level data, university mathematics and statistics, and the methods of CAS Exams 5, 6C, 7, 8 and 9 to study how well actuarial reserves, prices and capital estimates perform under realistic changes in the underlying claims process.**

---

## Appendix A: Changes from the October 2 scope and from the Combined draft

**Kept from October 2 (scope not reduced):** the pricing and capital/ERM phases; the Exam 7, 8 and 9 reading-to-build tables and the UTSC course map; the 10,000-year cat catalogue, Vasicek scenarios and bond portfolio; rating variables with sealed true relativities; MCT and the financial condition test; the retro and deductible material.

**Kept from the Combined draft:** research framing and secondary questions; tiers; hidden structural changes and anti-hindsight design; data-quality bridge; schemas; scoring and stochastic calibration; process-based dependence; method failure map; validation; reproducibility; deliverables; limitations; vertical-slice start.

**Fixes applied:**

1. **Guardrail moved and split.** The component check is now G1b at the end of Stage 2 (after cleaning), with G1a for raw-to-control and G1c for triangles. All checks use integer cents.
2. **Professional Liability propagated.** The carrier section, Tier 1 definition, research question 8, phase plan and report scope now treat Tier 1 as six lines; the schema is claims-made-ready from Phase 1.
3. **Every Tier 1 item now has a phase.** ALAE/ULAE (Phase 6), the 200-seed study (Phase 4), scoring (Phase 4) and the validation tests (Phases 3 and 5).
4. **Tier 1 report decoupled from Tier 2.** The report is finished in Phase 6; Professional Liability is an addendum.
5. **Human vs automated selections separated.** Selection policies P0 to P4 run in studies; the human workbook is used for the primary review; a new research question (11) compares them.
6. **JSON handoff specified.** Named Excel Tables read by header, schema validation, frozen JSON with a hash.
7. **Schedule P recast** as an acceptance target rather than an input source, with the limits stated.
8. **Time-to-detection defined** (threshold, persistence, censoring, signal-based variant, valuation frequency).
9. **Cash-flow schedule specified,** with sum and gross = ceded + net tests, and an LIC tie-out.
10. **Claim and transaction counts corrected** to reflect 4% growth (about 1.0 to 1.3 million claims; 8 to 15 million transactions).
11. **Schedule re-cut** into nine phases so the Core release does not wait for Tier 2.

**Open decisions for Leo:**

- Is Professional Liability at Tier 2 the right call, or should it return to Tier 1?
- Default `tau` for time-to-detection (5% proposed) and the valuation frequency (annual vs semi-annual).
- Number of seeds for the Tier 1 study (200 proposed).
- Whether Meyers-style MCMC stays Tier 3.
- Update `roadmap.png` from eight phases to nine.
- Whether MCT should instead be a Tier 1 stretch item (currently in the Capital track).
