# M_Lowest_Correlation_Pair

**Home table:** FACT_CORRELATION_MATRIX

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
