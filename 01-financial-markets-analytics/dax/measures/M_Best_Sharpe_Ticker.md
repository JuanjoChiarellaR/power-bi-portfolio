# M_Best_Sharpe_Ticker

**Home table:** VW_MARKET_ANALYTICS

```dax
M_Best_Sharpe_Ticker =
VAR SelectedTickers =
    ADDCOLUMNS(
        VALUES(VW_MARKET_ANALYTICS[TICKER]),
        "@Sharpe",
        CALCULATE([M_Sharpe_Ratio])
    )

VAR BestTicker =
    TOPN(
        1,
        FILTER(
            SelectedTickers,
            NOT ISBLANK([@Sharpe])
        ),
        [@Sharpe], DESC,
        VW_MARKET_ANALYTICS[TICKER], ASC
    )

RETURN
    CONCATENATEX(
        BestTicker,
        VW_MARKET_ANALYTICS[TICKER],
        ", "
    )
```

**Purpose:** Returns the ticker with the highest Sharpe Ratio within the
current selection. Alphabetical order is used as a tiebreaker.

**Format:** Text.
