# Technical Inventory

This inventory documents every visual across the five reports in the suite, verified directly from each report's saved definition (field references, table names, and aggregation functions), not just from visual inspection.

## Customer Analytics Report

| Visual | Business purpose | Fields | Aggregation / configuration |
|---|---|---|---|
| Donut chart | Compare revenue contribution by payment method | `Sales[Payment Method]`, `Sales[Order Total]` | Sum of Order Total |
| Treemap | Show the distribution of customer feedback categories | `Sales[Customer Feedback]`, `Sales[Customer ID]` | Count of Customer ID |
| Clustered bar chart | Compare revenue across customer locations | `Sales[Customer Location]`, `Sales[Order Total]` | Sum of Order Total |

## Order Operations Report

| Visual | Business purpose | Fields | Aggregation / configuration |
|---|---|---|---|
| Waterfall chart | Compare order volume by shipping method | `Sales[Shipping Method]`, `Sales[Order ID]` | Count of Order ID |
| Clustered column chart | Compare order volume across customer locations | `Sales[Customer Location]`, `Sales[Order ID]` | Count of Order ID |
| Pie chart | Monitor the composition of order statuses | `Sales[Order Status]`, `Sales[Order ID]` | Count of Order ID |

The waterfall chart displays shipping-method categories (Air, Ground) side by side with a running total. It is used here as a volume-comparison visual rather than a true sequential process breakdown.

## Product Sales Report

| Visual | Business purpose | Fields | Aggregation / configuration |
|---|---|---|---|
| Stacked area chart | Compare sales contribution across product colors | `Sales[Product Color]`, `Sales[Order Total]` | Sum of Order Total |
| Clustered bar chart | Compare sales across product categories and subcategories | `Sales[Product Subcategory]`, `Sales[Product Category]`, `Sales[Order Total]` | Sum of Order Total, grouped by Category/Subcategory hierarchy |
| Pie chart | Analyze sales mix by product size | `Sales[Product Size]`, `Sales[Order Total]` | Sum of Order Total |
| Clustered column chart | Monitor monthly product sales trends | `Sales[Order Date]` (Month level), `Sales[Order Total]` | Sum of Order Total |

## Business Performance Report

| Visual | Business purpose | Fields | Aggregation / configuration |
|---|---|---|---|
| Total Sales card | Headline revenue figure | Sales Amount | Sum |
| Average Sales card | Average order value | Sales Amount | Average |
| Total Orders card | Order count | Sales ID | Count non-blank |
| Total Marketing Spend card | Headline marketing investment | Marketing Spend | Sum |
| Monthly Sales multi-row card | Sales by month | Order Date (Month), Sales Amount | Sum of Sales Amount by Month |
| Monthly Marketing Spend multi-row card | Marketing spend by month | Order Date (Month), Marketing Spend | Sum of Marketing Spend by Month |
| Waterfall chart | Sales Amount by Month and Sales Team | Order Date (Month), Sales Team, Sales Amount, Marketing Spend (tooltip) | Sum of Sales Amount, broken down by Sales Team |
| Ribbon chart | Sales Amount by Month and Region, showing rank changes over time | Order Date (Month), Region, Sales Amount, Marketing Spend (tooltip) | Sum of Sales Amount by Month and Region |

This report's underlying data table uses field names consistent with the other four reports in spirit (`SalesAmount`, `SalesID`, `MarketingSpend`, `OrderDate`, `SalesTeam`, `Region`) but is a separate table from the `Sales`/`Customers` tables used elsewhere in the suite — see [`data-model.md`](data-model.md).

## Executive Summary Report

| Visual | Business purpose | Fields | Aggregation / configuration |
|---|---|---|---|
| KPI — Order Total Amount | Headline revenue indicator with trend | `Sales[Order Total]`, trend axis `Sales[OrderDate]` | Sum of Order Total |
| KPI — # Customers | Customer base size with trend | `Customers[Customer ID]`, trend axis `Sales[OrderDate]` | Count non-blank of Customer ID |
| KPI — # Cities | Geographic footprint with trend | `Customers[City]`, trend axis `Sales[OrderDate]` | Count non-blank of City |
| Clustered column chart | Order Total by Product Category, with quantity and weight in tooltips | `Sales[Product Category]`, `Sales[Order Total]`, `Sales[Order Quantity]`, `Sales[Product Weight]` | Sum of Order Total |
| Product Order Summary table | Order-level detail by product | `Sales[Product ID]`, `Sales[Product Name]`, `Sales[Order ID]`, `Sales[Order Status]`, `Sales[Order Total]` | Count non-blank of Product ID and Order ID; Sum of Order Total |
| Line chart — Daily Order Total and Forecast | Historical daily order total with a forward-looking forecast band | `Sales[OrderDate]` (Day level), `Sales[Order Total]` | Sum of Order Total, Power BI Analytics-pane Forecast enabled |
| Q&A visual | Natural-language exploration of the semantic model | — | Built-in Power BI Q&A |

## Explicit Measures

No explicit custom DAX measures were identified in any of the five reports. Every value shown — on cards, charts, KPIs, and tables — is an implicit aggregation (Sum, Average, Count non-blank) applied directly to a column, confirmed from each report's saved query definitions.

## Analytics Features

- **Forecast** (Executive Summary, "Daily Order Total and Forecast" line chart): Power BI's built-in Analytics-pane forecasting, confirmed with the following configuration: forecast unit 7 days, forecast length 10 units, ignore last 0, confidence level 99%, maximum seasonality 12. This is a statistical projection based on historical patterns, not a DAX calculation.
- **Q&A** (Executive Summary): a natural-language query box is present, allowing free-text questions against the semantic model. Power BI also surfaces its own suggested starter questions based on the model's field names.
- **Pinned tiles / Power BI Service dashboard**: see [`power-bi-service-dashboard.md`](power-bi-service-dashboard.md) — this artifact is a planned addition, not yet built at the time of writing.

## Model Observations

- Four of the five reports (Customer Analytics, Order Operations, Product Sales, Executive Summary) query a `Sales` table, and the Executive Summary report additionally queries a `Customers` table.
- The Business Performance report uses its own separate data table rather than the shared `Sales`/`Customers` tables used by the other four reports — the four "domain" reports and the standalone performance report were not built on a single unified model.
- Table relationships, cardinality, and storage mode (Import vs. DirectQuery) are not exposed in a plain-text-readable form within the saved file and would require opening each report in Power BI Desktop to confirm — this document only states what can be verified from each report's saved query and visual definitions.
