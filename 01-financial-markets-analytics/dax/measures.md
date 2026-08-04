# DAX Measures

## Performance & Risk Measures
**Home table:** VW_MARKET_ANALYTICS

### M_Cumulative_Return

```dax
M_Cumulative_Return =
VAR CurrentDate =
    MAX(VW_MARKET_ANALYTICS[PRICE_DATE])

VAR FirstSelectedDate =
    MINX(
        ALLSELECTED(VW_MARKET_ANALYTICS[PRICE_DATE]),
        VW_MARKET_ANALYTICS[PRICE_DATE]
    )

RETURN
    PRODUCTX(
        FILTER(
            ALLSELECTED(VW_MARKET_ANALYTICS[PRICE_DATE]),
            VW_MARKET_ANALYTICS[PRICE_DATE] >= FirstSelectedDate
                && VW_MARKET_ANALYTICS[PRICE_DATE] <= CurrentDate
        ),
        1
            + CALCULATE(
                AVERAGE(VW_MARKET_ANALYTICS[DAILY_RETURN])
            )
    ) - 1
```

**Purpose:** Calculates the cumulative return of each ticker from the start
of the selected date range up to the current date of each chart point.

**Responds to:** date range slicer, ticker slicer, individual line context.

**Format:** Percentage, 2 decimals.

### M_Annualized_Volatility

```dax
M_Annualized_Volatility =
STDEV.P(
    VW_MARKET_ANALYTICS[DAILY_RETURN]
) * SQRT(252)
```

**Purpose:** Measures the historical dispersion of daily returns and
annualizes it using the 252 trading-day convention.

**Format:** Percentage, 2 decimals.

### M_Historical_Annualized_Return

```dax
M_Historical_Annualized_Return =
AVERAGE(
    VW_MARKET_ANALYTICS[DAILY_RETURN]
) * 252
```

**Purpose:** Annualizes the average daily return observed in the selected
period.

**Note:** This is a historical annualized return, not an expected return or
forecast.

**Format:** Percentage, 2 decimals.

### M_Sharpe_Ratio

```dax
M_Sharpe_Ratio =
VAR AnnReturn =
    [M_Historical_Annualized_Return]

VAR AnnRiskFree =
    AVERAGE(
        VW_MARKET_ANALYTICS[RISK_FREE_RATE]
    ) * 252

VAR AnnVol =
    [M_Annualized_Volatility]

RETURN
    DIVIDE(
        AnnReturn - AnnRiskFree,
        AnnVol
    )
```

**Purpose:** Measures the excess historical return earned per unit of
volatility assumed for each asset.

**Format:** Decimal number, 2 decimals.

---

## Selection Context Measures (Performance Page)

### M_Selected_Assets

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

### M_Selected_Asset_Classes

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

---

## Best Sharpe Ratio Measures
**Home table:** VW_MARKET_ANALYTICS

### M_Best_Sharpe_Ratio

```dax
M_Best_Sharpe_Ratio =
MAXX(
    VALUES(VW_MARKET_ANALYTICS[TICKER]),
    CALCULATE([M_Sharpe_Ratio])
)
```

**Purpose:** Finds the highest Sharpe Ratio among the selected tickers,
respecting the selected date range.

**Format:** Decimal number, 2 decimals.

### M_Best_Sharpe_Ticker

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

### M_Best_Sharpe_Card

```dax
M_Best_Sharpe_Card =
VAR BestTicker =
    [M_Best_Sharpe_Ticker]

VAR BestSharpe =
    [M_Best_Sharpe_Ratio]

RETURN
    IF(
        ISBLANK(BestSharpe),
        BLANK(),
        BestTicker
            & " | "
            & FORMAT(BestSharpe, "0.00")
    )
```

**Purpose:** Combines the ticker and Sharpe value into a single measure
for card display.

**Example:** GLD | 1.01
**Card title:** Best Risk-Adjusted Performer.

---

## Lowest Volatility Measures

### M_Lowest_Volatility

```dax
M_Lowest_Volatility =
MINX(
    VALUES(VW_MARKET_ANALYTICS[TICKER]),
    CALCULATE([M_Annualized_Volatility])
)
```

**Purpose:** Finds the lowest annualized volatility among the selected
tickers within the selected date range.

**Format:** Percentage, 2 decimals.

### M_Lowest_Volatility_Ticker

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

### M_Lowest_Volatility_Card

```dax
M_Lowest_Volatility_Card =
VAR LowestTicker =
    [M_Lowest_Volatility_Ticker]

VAR LowestVolatility =
    [M_Lowest_Volatility]

RETURN
    IF(
        ISBLANK(LowestVolatility),
        BLANK(),
        LowestTicker
            & " | "
            & FORMAT(LowestVolatility, "0.00%")
    )
```

**Purpose:** Displays the ticker and its volatility in a single card.

**Example:** AGG | 4.47%
**Card title:** Lowest Volatility.

---

## Correlation Matrix Measures
**Home table:** FACT_CORRELATION_MATRIX

### M_Selected_Correlation

```dax
M_Selected_Correlation =
VAR CurrentTickerA =
    SELECTEDVALUE(
        FACT_CORRELATION_MATRIX[TICKER_A]
    )

VAR CurrentTickerB =
    SELECTEDVALUE(
        FACT_CORRELATION_MATRIX[TICKER_B]
    )

VAR SelectedTickers =
    ALLSELECTED(
        DIM_TICKER_FILTER[TICKER]
    )

RETURN
    IF(
        CONTAINSROW(
            SelectedTickers,
            CurrentTickerA
        )
            && CONTAINSROW(
                SelectedTickers,
                CurrentTickerB
            ),
        AVERAGE(
            FACT_CORRELATION_MATRIX[CORRELATION]
        ),
        BLANK()
    )
```

**Purpose:** Displays a correlation value only when both TICKER_A and
TICKER_B belong to the disconnected slicer selection. Also respects the
WINDOW_YEARS filter.

**Format:** Decimal number, 2 decimals.

### M_Lowest_Correlation

```dax
M_Lowest_Correlation =
VAR SelectedPairs =
    FILTER(
        FACT_CORRELATION_MATRIX,
        FACT_CORRELATION_MATRIX[TICKER_A]
            <> FACT_CORRELATION_MATRIX[TICKER_B]
            && CONTAINSROW(
                ALLSELECTED(
                    DIM_TICKER_FILTER[TICKER]
                ),
                FACT_CORRELATION_MATRIX[TICKER_A]
            )
            && CONTAINSROW(
                ALLSELECTED(
                    DIM_TICKER_FILTER[TICKER]
                ),
                FACT_CORRELATION_MATRIX[TICKER_B]
            )
    )

RETURN
    MINX(
        SelectedPairs,
        FACT_CORRELATION_MATRIX[CORRELATION]
    )
```

**Purpose:** Finds the lowest correlation among selected assets,
excluding the diagonal where a ticker is compared with itself.

**Format:** Decimal number, 2 decimals.
**Note:** This numeric measure supports analysis/formatting; the final
card uses the text-pair measure below.

### M_Lowest_Correlation_Pair

```dax
M_Lowest_Correlation_Pair =
VAR SelectedPairs =
    FILTER(
        FACT_CORRELATION_MATRIX,
        FACT_CORRELATION_MATRIX[TICKER_A]
            < FACT_CORRELATION_MATRIX[TICKER_B]
            && CONTAINSROW(
                ALLSELECTED(
                    DIM_TICKER_FILTER[TICKER]
                ),
                FACT_CORRELATION_MATRIX[TICKER_A]
            )
            && CONTAINSROW(
                ALLSELECTED(
                    DIM_TICKER_FILTER[TICKER]
                ),
                FACT_CORRELATION_MATRIX[TICKER_B]
            )
    )

VAR LowestPair =
    TOPN(
        1,
        SelectedPairs,
        FACT_CORRELATION_MATRIX[CORRELATION], ASC,
        FACT_CORRELATION_MATRIX[TICKER_A], ASC,
        FACT_CORRELATION_MATRIX[TICKER_B], ASC
    )

RETURN
    CONCATENATEX(
        LowestPair,
        FACT_CORRELATION_MATRIX[TICKER_A]
            & " / "
            & FACT_CORRELATION_MATRIX[TICKER_B]
            & " | "
            & FORMAT(
                FACT_CORRELATION_MATRIX[CORRELATION],
                "0.00"
            )
    )
```

**Purpose:** Identifies the selected pair with the lowest correlation.
The condition TICKER_A < TICKER_B avoids evaluating symmetric pairs twice
(e.g. AGG/IEF and IEF/AGG).

**Example:** IEF / QQQ | -0.02
**Card title:** Lowest Correlation Pair.

### M_Highest_Correlation_Pair

```dax
M_Highest_Correlation_Pair =
VAR SelectedPairs =
    FILTER(
        FACT_CORRELATION_MATRIX,
        FACT_CORRELATION_MATRIX[TICKER_A]
            < FACT_CORRELATION_MATRIX[TICKER_B]
            && CONTAINSROW(
                ALLSELECTED(
                    DIM_TICKER_FILTER[TICKER]
                ),
                FACT_CORRELATION_MATRIX[TICKER_A]
            )
            && CONTAINSROW(
                ALLSELECTED(
                    DIM_TICKER_FILTER[TICKER]
                ),
                FACT_CORRELATION_MATRIX[TICKER_B]
            )
    )

VAR HighestPair =
    TOPN(
        1,
        SelectedPairs,
        FACT_CORRELATION_MATRIX[CORRELATION], DESC,
        FACT_CORRELATION_MATRIX[TICKER_A], ASC,
        FACT_CORRELATION_MATRIX[TICKER_B], ASC
    )

RETURN
    CONCATENATEX(
        HighestPair,
        FACT_CORRELATION_MATRIX[TICKER_A]
            & " / "
            & FACT_CORRELATION_MATRIX[TICKER_B]
            & " | "
            & FORMAT(
                FACT_CORRELATION_MATRIX[CORRELATION],
                "0.00"
            )
    )
```

**Purpose:** Identifies the distinct pair with the highest correlation
among selected assets. Automatically excludes the diagonal and duplicate
pairs via TICKER_A < TICKER_B.

**Example:** AGG / IEF | 0.97
**Card title:** Most Similar Pair.

---

## Asset Detail Measures
**Home table:** VW_MARKET_ANALYTICS

### M_Latest_Adj_Close

```dax
M_Latest_Adj_Close =
VAR LatestDate =
    MAX(
        VW_MARKET_ANALYTICS[PRICE_DATE]
    )

RETURN
    CALCULATE(
        MAX(
            VW_MARKET_ANALYTICS[ADJ_CLOSE]
        ),
        VW_MARKET_ANALYTICS[PRICE_DATE] = LatestDate
    )
```

**Purpose:** Returns the adjusted price for the latest date within the
selected period.

**Format:** Currency, 2 decimals.

### M_Latest_Volume

```dax
M_Latest_Volume =
VAR LatestDate =
    MAX(
        VW_MARKET_ANALYTICS[PRICE_DATE]
    )

RETURN
    CALCULATE(
        MAX(
            VW_MARKET_ANALYTICS[VOLUME]
        ),
        VW_MARKET_ANALYTICS[PRICE_DATE] = LatestDate
    )
```

**Purpose:** Returns the trading volume for the latest date of the
selected ticker.

**Format:** Whole number; may be displayed in millions on the visual.

### M_Period_High

```dax
M_Period_High =
MAX(
    VW_MARKET_ANALYTICS[ADJ_CLOSE]
)
```

**Purpose:** Finds the highest adjusted price within the selected date
range and ticker.

**Format:** Currency, 2 decimals.

### M_Period_Low

```dax
M_Period_Low =
MIN(
    VW_MARKET_ANALYTICS[ADJ_CLOSE]
)
```

**Purpose:** Finds the lowest adjusted price within the selected date
range and ticker.

**Format:** Currency, 2 decimals.
