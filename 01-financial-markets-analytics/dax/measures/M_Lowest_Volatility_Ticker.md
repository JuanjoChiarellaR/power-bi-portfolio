# M_Lowest_Volatility_Ticker

**Home table:** VW_MARKET_ANALYTICS

```dax
M_Lowest_Volatility_Ticker =
VAR SelectedTickers =
    ADDCOLUMNS(
        VALUES(VW_MARKET_ANALYTICS[TICKER]),
        "@Volatility",
        CALCULATE([M_Annualized_Volatility])
    )

VAR LowestTicker =
    TOPN(
        1,
        FILTER(
            SelectedTickers,
            NOT ISBLANK([@Volatility])
        ),
        [@Volatility], ASC,
        VW_MARKET_ANALYTICS[TICKER], ASC
    )

RETURN
    CONCATENATEX(
        LowestTicker,
        VW_MARKET_ANALYTICS[TICKER],
        ", "
    )
```

**Purpose:** Returns the ticker with the lowest annualized volatility
within the current selection.

**Format:** Text.
