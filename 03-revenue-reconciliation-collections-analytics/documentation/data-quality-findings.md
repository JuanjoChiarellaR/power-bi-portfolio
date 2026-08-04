# Data-Quality Findings

Two source-system data-quality issues were identified during this analysis. Neither invalidates the analysis — both are flagged transparently as limitations of the current source-system recording logic.

## 1. Pre-payment misclassification

**Description:** Payments for future-period service (Summer 2026 and Fall 2026 in the underlying data) are posted at transaction date rather than deferred to the fiscal year when service is actually delivered.

**Impact:** Overstates current-year (FY2025-26) revenue; understates the balance-sheet liability owed to customers for future service.

**Verification:** This finding is independently corroborated by the model's own numbers, not just asserted. The `Deferred_Revenue` measure — which should always be positive, since deferred revenue is a liability — returns a **negative** value in two consecutive fiscal years: ($73,372.50) in FY2024-25 and ($4,095) in FY2025-26. A negative deferred-revenue balance is an accrual-accounting impossibility and is exactly what would result if future-period prepayments were being posted as current charges instead of deferred income. The fact that this appears in two consecutive years (not just one) suggests the issue is systemic rather than a one-time error.

## 2. Placeholder application ID

**Description:** A bridge/staging query in the model's Power Query layer links applications to entries by `application_id`. 345 entries reportedly carry a placeholder `application_id` value of 2,147,483,647 (the maximum 32-bit signed integer — a common "unassigned" sentinel value) instead of a valid link; 70 of those reportedly have associated accounting transactions.

**Impact:** Minor — documented as a source-system data-entry gap that creates incomplete traceability between a small subset of applications/bookings and their accounting transactions.

**Verification:** The underlying mechanism is confirmed present in the model — `fact_applications_and_bookings` is built via a left-outer join against a bridge query on `application_id`, exactly as this finding describes (see [`../power-query/transformations.md`](../power-query/transformations.md)). The specific counts (345 total, 70 with transactions) reflect the original data review and were not independently recomputed against the live source for this documentation, since that would require re-running the query against the database directly rather than inspecting the saved model.

## What this means for the numbers in this report

Both issues affect the *classification* of specific transactions, not the overall transaction volume or the model's calculation logic. The `Outstanding_Receivables` and `Revenue_Recognized_FY` figures reported throughout this project are the model's actual output — the findings above explain *why* certain figures (particularly FY2025-26's revenue and deferred-revenue balance) should be read with the understanding that a source-system fix is still pending, not that the reported figures are wrong given the current data.
