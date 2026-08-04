# Revenue Recognition Methodology

This is the recognition methodology used in this portfolio case, not legal or accounting advice.

Revenue recognition follows a service-delivery principle: income is recorded when service is delivered, not when payment is received.

| Term Type | Recognition Rule |
|---|---|
| Fall / Spring | 100% recognized in the fiscal year the service occurs. No proration required — both terms fall entirely within a single fiscal year. |
| Summer (straddles June 30) | Prorated by days: `(days in current FY / total term days) × total revenue for that term`. Applied per session (Full, A, B, C, D). |
| Pre-payments for future FY | Classified as Deferred Revenue and excluded from the current-year P&L. Revenue recognized only in the fiscal year when service is delivered. |

## How this is implemented in the model

- The fiscal year itself is computed entirely in DAX via a custom calendar table (`dim_Calendar`), with a July 1–June 30 fiscal year built from `CALENDARAUTO(6)` — see [`../dax/calculated-tables.md`](../dax/calculated-tables.md).
- "Earned revenue" (`Revenue_Recognized_FY`) is defined as the sum of Room & Board charge categories only, which the Executive Overview confirms represent ~91% of all charges — see [`../dax/measures.md`](../dax/measures.md).
- "Deferred revenue" is a dedicated measure summing transactions specifically categorized as `DEFERRED INCOME` in the source system.
- The Summer-session day-proration logic described in the rule above is a stated business rule rather than a DAX formula directly observable in the model's measures — the model's `Revenue_Recognized_FY` measure sums already-categorized Room & Board charges rather than performing day-level proration itself. This is noted for accuracy rather than glossed over.

## Verified observation

The published dashboard's own numbers are internally consistent with this methodology: FY2024-25 shows a 103.1% collection rate (more cash collected than revenue recognized, consistent with early prepayments landing in that period), and both FY2024-25 and FY2025-26 show negative deferred-revenue balances — an accrual-accounting impossibility that indicates prepayments are being posted as current-year charges instead of being deferred. See [`data-quality-findings.md`](data-quality-findings.md).
