# M_Selected_Assets

**Home table:** VW_MARKET_ANALYTICS

```dax
M_Selected_Assets =
DISTINCTCOUNT(
    VW_MARKET_ANALYTICS[TICKER]
)
```

**Purpose:** Counts how many tickers remain visible after applying the
page filters.

**Format:** Whole number.
**Card title:** Selected Assets.
