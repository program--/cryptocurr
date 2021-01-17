tibble_class <- c("tbl_df", "tbl", "data.frame")

funding_names <- c(
    "SYMBOL",
    "FRR",
    "BID",
    "BID_PERIOD",
    "BID_SIZE",
    "ASK",
    "ASK_PERIOD",
    "ASK_SIZE",
    "DAILY_CHANGE",
    "DAILY_CHANGE_RELATIVE",
    "LAST_PRICE",
    "VOLUME",
    "HIGH",
    "LOW",
    "FRR_AMOUNT_AVAILABLE"
)

trading_names <- c(
    "SYMBOL",
    "BID",
    "BID_SIZE",
    "ASK",
    "ASK_SIZE",
    "DAILY_CHANGE",
    "DAILY_CHANGE_RELATIVE",
    "LAST_PRICE",
    "VOLUME",
    "HIGH",
    "LOW"
)

is_maintenance <- identical(get_status(), "Maintenance")

## TESTS ##

test_that("Bitfinex get_status() works", {
    test_value <- get_status()

    # Check that get_status() returns a character
    expect_type(test_value, "character")

    # Check that get_status() is a character of length 1
    expect_length(test_value, 1)

    # Check that get_status() returns the correct characters
    expect_true(test_value %in% c("Operative", "Maintenace"))
})

test_that("Bitfinex tickers() works", {
    skip_if(is_maintenance, "Bitfenix API in Maintenance mode")

    test_value <- tickers()

    # Check that tickers() returns a list
    expect_type(test_value, "list")

    # Check that tickers() returns a list of length 2
    expect_length(test_value, 2)

    # Check that tickers() returns a tibble for its attributes
    expect_s3_class(test_value$funding, tibble_class)
    expect_s3_class(test_value$trading, tibble_class)
    expect_true(tibble::is_tibble(test_value$funding))
    expect_true(tibble::is_tibble(test_value$trading))

    # Check that tickers() returns an error if SYMBOLS isn't valid
    expect_error(tickers("fakecoin"))

    # Check that tickers()$funding has correct colnames
    expect_identical(
        names(test_value$funding),
        funding_names
    )

    # Check that tickers()$trading has correct colnames
    expect_identical(
        names(test_value$trading),
        trading_names
    )
})

test_that("Bitfinex ticker() works", {
    skip_if(is_maintenance, "Bitfenix API in Maintenance mode")

    test_value  <- ticker()
    test_value2 <- ticker("fUSD")

    # Check that ticker() returns a tibble
    expect_s3_class(test_value, tibble_class)
    expect_s3_class(test_value2, tibble_class)
    expect_true(tibble::is_tibble(test_value))
    expect_true(tibble::is_tibble(test_value2))

    # Check that ticker() returns a single row tibble
    expect_true(nrow(test_value) == 1)
    expect_true(nrow(test_value2) == 1)

    # Check that ticker() and ticker("fUSD") return the correct tickers
    expect_equal(test_value[[1]], "tBTCUSD")
    expect_equal(test_value2[[1]], "fUSD")

    # Check that column names match trading/funding names
    expect_identical(names(test_value), trading_names)
    expect_identical(names(test_value2), funding_names)

    # Check that ticker() returns error when passed invalid symbol
    expect_error(ticker("fakecoin"))
})

test_that("Bitfinex ticker_history() works", {
    skip_if(is_maintenance, "Bitfenix API in Maintenance mode")

    test_value <- ticker_history()

    # Check that ticker_history() returns a tibble
    expect_s3_class(test_value, tibble_class)
    expect_true(tibble::is_tibble(test_value))

    # Check that tibble has correct column names
    expect_identical(
        names(test_value),
        c("SYMBOL", "BID", "ASK", "MTS")
    )

    # Check that error handling is working
    expect_error(ticker_history(limit = 251))
    expect_error(ticker_history(SYMBOLS = "fakecoin"))

    # Check that a call gives correct ticker
    expect_equal(
        unique(ticker_history(SYMBOLS = "tBTCUSD")$SYMBOL),
        "tBTCUSD"
    )
})

test_that("Bitfenix trades() works", {
    skip_if(is_maintenance, "Bitfenix API in Maintenance mode")

    test_value <- trades()

    # Check that ticker_history() returns a tibble
    expect_s3_class(test_value, tibble_class)
    expect_true(tibble::is_tibble(test_value))

    # Check that tibble has correct column names
    expect_identical(
        names(test_value),
        c("SYMBOL", "ID", "MTS", "AMOUNT", "PRICE")
    )

    expect_identical(
        names(trades(SYMBOL = "fUSD")),
        c("SYMBOL", "ID", "MTS", "AMOUNT", "RATE", "PERIOD")
    )

    # Check that error handling is working
    expect_error(ticker_history(limit = 10001))
    expect_error(ticker_history(SYMBOL = "fakecoin"))
})
