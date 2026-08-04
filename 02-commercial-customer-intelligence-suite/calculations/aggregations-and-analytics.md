# Aggregations and Analytics Configuration

All five reports in this suite rely on Power BI's implicit aggregations — Sum, Average, and Count non-blank applied directly to a column — rather than a custom DAX measure layer. This was confirmed by inspecting each report's saved query definitions: no visual references a named measure anywhere in the suite.

## Customer Analytics Report

- Sum of Order Total by Payment Method.
- Count of Customer ID by Customer Feedback.
- Sum of Order Total by Customer Location.

## Order Operations Report

- Count of Order ID by Shipping Method.
- Count of Order ID by Customer Location.
- Count of Order ID by Order Status.

## Product Sales Report

- Sum of Order Total by Product Color.
- Sum of Order Total by Product Category and Product Subcategory.
- Sum of Order Total by Product Size.
- Sum of Order Total by Order Month.

## Business Performance Report

- Sum of Sales Amount.
- Average of Sales Amount.
- Count non-blank of Sales ID.
- Sum of Marketing Spend.
- Sum of Sales Amount by Month.
- Sum of Marketing Spend by Month.
- Sum of Sales Amount by Month and Sales Team, with Marketing Spend as tooltip.
- Sum of Sales Amount by Month and Region, with Marketing Spend as tooltip.

## Executive Summary Report

- Sum of Order Total.
- Count non-blank of Customer ID.
- Count non-blank of City.
- Sum of Order Total by Product Category, with Order Quantity and Product Weight in tooltips.
- Count non-blank of Product ID and Order ID in the Product Order Summary table.
- Daily Sum of Order Total, with forecast.

## Forecast Configuration

Confirmed directly from the report's saved analytics configuration on the "Daily Order Total and Forecast" line chart:

```text
Forecast unit: 7 days
Forecast length: 10 units
Ignore last: 0
Confidence level: 99%
Maximum seasonality: 12
```

This is configured through the line chart's Analytics pane in Power BI — a built-in statistical forecasting feature, not a DAX calculation. It projects the historical daily order-total series forward and displays a confidence band around the projection; it is a pattern-based estimate, not a guaranteed outcome.

## Q&A Configuration

A Q&A visual is present in the Executive Summary report, allowing free-text natural-language questions against the semantic model. Power BI generates its own starter suggestions based on the model's field names (for example, prompts related to customer counts and order dates). No additional linguistic customization (custom synonyms, phrasing rules) was found configured beyond Power BI's default behavior.
