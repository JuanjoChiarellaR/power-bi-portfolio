# M_Selected_Asset_Classes

**Home table:** VW_MARKET_ANALYTICS

```dax
M_Selected_Asset_Classes =
DISTINCTCOUNT(
    VW_MARKET_ANALYTICS[ASSET_CLASS]
)
```

**Purpose:** Counts how many asset classes are represented among the
selected tickers.

**Format:** Whole number.
**Card title:** Selected Asset Classes.
