# Business Case

## Overview

This project analyzes a real-world revenue recognition and collections challenge for a global experiential-education organization, using a business dataset to design and build a board-level Power BI solution. The organization runs multi-month service programs (academic-term and summer sessions) and collects customer payments — deposits, installments, and full prepayments — up to 12 months before service is delivered.

## The problem

Because programs can cross fiscal-year boundaries, cash receipt dates don't always align with revenue recognition dates. Finance needs a reliable way to distinguish:

- revenue actually **earned** in a given fiscal year,
- cash **collected** against that revenue,
- **outstanding receivables** still owed by customers,
- **deferred revenue** — prepayments collected for service not yet delivered,

while catching posting anomalies in the source system before fiscal close.

## Why it matters

Without this distinction, a fiscal year can look financially healthier or worse than it actually is: revenue collected early for a future year can make the current year look artificially strong, while unresolved receivables from prior years can hide in an aggregate "outstanding" total without anyone noticing which year they actually belong to. This is exactly the confusion this project's own source materials initially contained — see [`data-quality-findings.md`](data-quality-findings.md) — before being corrected.

## Approach

1. Ingest transactional data from a cloud-hosted MySQL database into Power BI (Import mode).
2. Structure the data into an analytical model with two fact tables (accounting transactions, applications and bookings) and shared dimensions (entries, terms, a custom fiscal-year calendar).
3. Translate fiscal-year revenue-recognition rules into DAX (see [`revenue-recognition-methodology.md`](revenue-recognition-methodology.md)).
4. Deliver a two-page executive report: a program-wide overview, and a fiscal-year-level revenue and collections briefing with board-ready recommendations.
