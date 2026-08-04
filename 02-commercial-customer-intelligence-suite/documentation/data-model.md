# Data Model

## Tables observed

Based on the fields referenced across the five reports' saved query definitions:

- **`Sales`** — used by the Customer Analytics, Order Operations, Product Sales, and Executive Summary reports. Observed fields include Payment Method, Customer Feedback, Customer Location, Order Total, Shipping Method, Order ID, Order Status, Product Color, Product Category, Product Subcategory, Product Size, Order Date, Product ID, Product Name, Order Quantity, and Product Weight.
- **`Customers`** — used by the Executive Summary report. Observed fields include Customer ID and City.
- **Business Performance's own sales table** — a separate table used only by the Business Performance report, with fields covering Sales Amount, Sales ID, Marketing Spend, Order Date, Sales Team, and Region. It is not the same table as `Sales`/`Customers` used by the other four reports.

## What this means for the suite

The four domain reports (Customer, Order, Product, Executive Summary) draw from a shared `Sales`/`Customers` structure, while the Business Performance report was built independently on its own table. This is documented as observed, not assumed — the suite is not presented as a single unified star schema, since that would overstate what's verifiable from the saved report definitions alone.

## Limitations of this documentation

Table relationships, cardinality, and storage mode (Import vs. DirectQuery) are not exposed in a plain-text-readable form within a saved Power BI file — that detail lives in a compressed internal data model that would require opening each report in Power BI Desktop to inspect directly. This document reflects only what can be verified from each report's saved query and visual definitions: which tables and fields each visual actually queries.
