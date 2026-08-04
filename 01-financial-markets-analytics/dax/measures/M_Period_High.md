# M_Period_High

**Home table:** VW_MARKET_ANALYTICS

```dax
M_Period_High =
MAX(
    VW_MARKET_ANALYTICS[ADJ_CLOSE]
)
```

**Purpose:** Finds the highest adjusted price within the selected date
range and ticker.

**Format:** Currency, 2 decimals.
