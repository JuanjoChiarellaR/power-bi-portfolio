# M_Period_Low

**Home table:** VW_MARKET_ANALYTICS

```dax
M_Period_Low =
MIN(
    VW_MARKET_ANALYTICS[ADJ_CLOSE]
)
```

**Purpose:** Finds the lowest adjusted price within the selected date
range and ticker.

**Format:** Currency, 2 decimals.
