# Architecture

This project follows a 5-layer pipeline, from raw public data to a Power BI dashboard.

## 1. Source

[FFIEC HMDA public Data Browser API](https://ffiec.cfpb.gov/v2/data-browser-api/) — Home Mortgage Disclosure Act data, activity year 2023, 20 US states, individual owner-occupant home-purchase/refinance applications. This is real, publicly available regulatory data published by the Consumer Financial Protection Bureau (CFPB); no synthetic or simulated records are used anywhere in this project.

## 2. Ingestion

Python (`pandas`, `boto3`, `pyarrow`) in Jupyter. The FFIEC API only accepts up to two filter criteria per request, so data is pulled one state at a time. Each state's results are written to S3 as Parquet.

## 3. Landing (S3 + Glue/Athena)

Raw Parquet files land in `s3://hmda-funnel-analytics-juanjo/raw/`, registered as the external Athena table `hmda_funnel.applications`.

## 4. Semantic model (SQL/Athena)

- `v_applications_semantic` — row-level view. Cleans HMDA's `"Exempt"`/`"NA"` placeholder strings to `NULL` via `TRY_CAST`, labels funnel stages and leakage category, computes loan-to-value (LTV).
- `v_dashboard_agg` — aggregated view built on top of `v_applications_semantic`. Applies percentile-based banding on income, loan amount, property value, LTV, rate spread, and DTI, and prunes dimensions to keep the dataset a manageable size for Power BI.

## 5. Power BI

The aggregated CSV is uploaded directly as a semantic model in Power BI Service (no Power BI Desktop/Fabric capacity available in this setup), with DAX measures built on top using `DIVIDE(SUM, SUM)` weighted-average patterns.

---

## Key design decisions

**Issuance leakage definition.** Issuance leakage is defined strictly as `action_taken IN (2, 8)` — Approved not accepted / Preapproval approved not accepted. A denial (`action_taken = 3`) is a risk-based decision by the lender, not issuance leakage; it is tracked separately as `Risk-based leakage`.

**Funnel structure.** The funnel has 4 stages — Applications → Reached Decision → Approved → Originated — built so that all 7 relevant `action_taken` codes (1, 2, 3, 4, 5, 7, 8) are counted in stage 1 (Applications). This preserves a true nested-subset funnel, where every later stage is a strict subset of the stage before it.

**Data limitation, documented not imputed.** `property_value`, `rate_spread`, `interest_rate`, and cost fields (`total_loan_costs`, `origination_charges`, `discount_points`) are ~100% absent for Withdrawn/Incomplete applications, because those applications never reached appraisal/underwriting. These are left labeled as `"Unknown"` in the banded dimensions rather than imputed — imputing a value for an application that never reached that stage of the process would misrepresent the funnel.

**Weighted averages.** Because `v_dashboard_agg` is pre-aggregated (one row per dimension combination, not one row per application), every average in DAX is computed as `DIVIDE(SUM(total), SUM(count), 0)`. A plain `AVERAGE()` over pre-aggregated rows would average the group averages themselves, not the underlying applications, and silently misweight small groups.

**Banding.** Numeric bands (income, loan amount, property value, LTV, rate spread) are anchored to real percentile breakpoints from the data — not round numbers — so each band reflects an actual distributional cut of the dataset rather than an arbitrary threshold.

---

## DAX measures reference

Key measures built on top of `v_dashboard_agg` in Power BI:

- `Total Applications`
- `Total Loan Amount`
- `% Originated Total Rate`
- `$ Approved Not Converted Loan Amount`
- `Approved Not Converted Quantity`
- `Issuance Leakage Loan Amount Rate`
- `Issuance Leakage Quantity Rate`
- `AVG Rate Spread (Originated)` vs. `AVG Rate Spread (Approved Not Converted)`
- `Funnel Applications Quantity`
- `Funnel Applications Loan Amount`
