# M_Highest_Correlation_Pair

**Home table:** FACT_CORRELATION_MATRIX

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
