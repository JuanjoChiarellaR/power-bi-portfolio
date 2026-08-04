# Power BI Service Dashboard and Pinned Tiles

## Report vs. dashboard

A **Power BI report** is a multi-visual, interactive analytical surface — it can have multiple pages, supports filtering and cross-highlighting between visuals, and is built in Power BI Desktop. The five reports in this suite are each a report in this sense.

A **Power BI Service dashboard** is a different artifact: a single page composed of **tiles**, where each tile is a snapshot of one visual pinned from a report. Dashboards are built directly in the Power BI Service (the web app), not in Desktop, and they exist specifically to combine information from multiple reports into one monitoring view.

## How pinning works

After a report is published to the Power BI Service, any individual visual on it can be pinned to a dashboard as a tile. Pinning does not merge the underlying semantic models or create new calculations — a tile simply displays that visual's current result and, where configured, can be clicked to navigate back to the source report for full interactivity (filtering, drill-down, tooltips).

## Why this suite uses one

> After the specialized reports were published, selected KPIs and visuals were pinned to a Power BI Service dashboard. This created a single executive monitoring layer across customer, order, product, sales, and performance views without removing the detailed analysis available in the original reports.

The intent is to give a leader a single page to check at a glance — headline revenue, order volume, top-line customer and product metrics — while preserving full access to each underlying report for anyone who needs to dig deeper.

## Status: pending

**This dashboard has not been built/exported yet.** No screenshot, PDF, or PBIX artifact for it exists in this repository at the time of writing. Required assets once available:

- [ ] Dashboard screenshot (`images/executive-dashboard.png`)
- [ ] Dashboard PDF export, if available (`pdf/executive-dashboard.pdf`)

Until then, this document describes the intended design and mechanism rather than a specific set of tiles or metrics — no dashboard content is invented here.

## Limitations of static exports

A live Power BI Service dashboard is interactive: tiles refresh with the underlying data and can be clicked through to the source report. The PDF exports and screenshots in this repository are static snapshots of the five reports at a point in time — useful for browser-based review without Power BI Desktop, but they don't reproduce the click-through navigation or live refresh of the actual Service experience.
