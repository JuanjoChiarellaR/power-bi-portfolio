# Solution Overview

## Two-level design

This suite is organized in two layers:

1. **Domain-specific reports** — five focused Power BI reports, each built around one business domain: customers, orders, products, commercial performance, and an executive summary. Each report answers a narrow set of questions in depth, using the visuals and aggregations best suited to that domain.
2. **Executive dashboard** — selected KPIs and visuals from across the five reports are pinned into a single Power BI Service dashboard, giving leadership a one-page monitoring view without replacing the detailed reports underneath it.

This separation keeps analysis (multi-visual, filterable, domain-specific reports) distinct from monitoring (a compact, at-a-glance dashboard). See [`power-bi-service-dashboard.md`](power-bi-service-dashboard.md) for how the two layers connect.

## Why five reports instead of one

Each report was designed and published independently, focused on a single business domain. Rather than force customer, order, product, and commercial-performance analysis into a single crowded report, the suite keeps each analytical view purpose-built — then reconnects them at the monitoring layer through pinned tiles. This mirrors how BI suites are typically organized in practice: specialized reports for analysts, a consolidated dashboard for executives.

## Report roles

| Report | Role |
|---|---|
| Customer Analytics Report | Payment behavior, feedback patterns, and geographic revenue distribution |
| Order Operations Report | Order volume, status, and shipping-method distribution |
| Product Sales Report | Product mix by category, subcategory, color, size, and month |
| Business Performance Report | Commercial performance: sales trend, marketing spend, sales-team and regional contribution |
| Executive Summary Report | Cross-cutting KPIs, product performance, order-level detail, forecast, and natural-language Q&A |

Full detail on each report's visuals and fields is in [`technical-inventory.md`](technical-inventory.md); verified aggregation logic is in [`../calculations/aggregations-and-analytics.md`](../calculations/aggregations-and-analytics.md).
