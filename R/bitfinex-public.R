#' @title Get Bitfinex platform status
#' @description Calls the Bitfinex API to determine platform operative status.
#' @return Either "Operative" if platform is usable, or "Maintenace".
#' @examples
#' \dontrun{
#'     print(get_status())
#'     # Output:
#'     # [1] "Operative"
#' }
#' @export
get_status <- function() {
    bit_url <- "https://api-pub.bitfinex.com/v2/platform/status"

    platform_status <- httr::GET(bit_url) %>%
                       httr::content()

    dplyr::if_else(
        platform_status[[1]] == 1,
        "Operative",
        "Maintenace"
    )
}

#' @title Retrieve Cryptocurrency Data
#' @description Calls the Bitfinex API to retrieve cryptocurrency data.
#' @param SYMBOLS Character vector containing ticker symbols for
#'                cryptocurrencies, or \code{ALL} for all possible tickers.
#'                Must be prepended with a \code{t} or \code{f} to specify
#'                trading or funding cryptocurrencies, respectively.
#' @return A \code{list} with \code{tibble} attributes:
#'         \code{funding} and \code{trading}. See details.
#' @details
#' ### `tibble` descriptions:
#' * `SYMBOL`: The symbol/ticker of the requested data
#' * `FRR`: Flash Return Rate - average of all fixed rate funding over
#'          the last hour *(funding tickers only)*
#' * `BID`: Price of last highest bid
#' * `BID_PERIOD`: Bid period covered in days *(funding tickers only)*
#' * `BID_SIZE`: Sum of the 25 highest bid sizes
#' * `ASK`: Price of last lowest ask
#' * `ASK_PERIOD`: Ask period covered in days *(funding tickers only)*
#' * `ASK_SIZE`: Sum of the 25 lowest ask sizes
#' * `DAILY_CHANGE`: Amount that the last price has changed since yesterday
#' * `DAILY_CHANGE_RELATIVE`: Relative price change since yesterday
#'                           (*100 for percentage change)
#' * `LAST_PRICE`: Price of the last trade
#' * `VOLUME`: Daily volume
#' * `HIGH`: Daily high
#' * `LOW`: Daily low
#' * `FRR_AMOUNT_AVAILABLE`: The amount of funding that is available at
#'                           the Flash Return Rate *(funding tickers only)*
#' @md
#' @examples
#' \dontrun{
#'     # Get Bitcoin and Litecoin info
#'     tickers(SYMBOLS = c("tBTCUSD", "tLTCUSD"))
#'     # Returns $trading tibble with 2 rows
#'     # and $funding tibble with 0 rows
#'
#'     # Get USD info
#'     tickers(SYMBOLS = "USD")
#'     # Return $trading tibble with 0 rows
#'     # and $funding tibble with 1 row
#' }
#' @export
tickers <- function(SYMBOLS = c("ALL")) {
    bit_url <- "https://api-pub.bitfinex.com/v2/tickers"
    query   <- paste0(bit_url,
                      "?symbols=",
                      paste(SYMBOLS, collapse = ","))

    api_call <- httr::GET(query)

    httr::stop_for_status(
        api_call,
        task = paste("get symbol", SYMBOLS)
    )

    api_call <- httr::content(api_call)

    if (length(api_call) == 0) {
        stop("\n\tsymbols are invalid:\n\t\t",
             paste(SYMBOLS, collapse = "\n\t\t"))
    }

    funding <- trading <- tibble::tibble()

    lapply(
        api_call,
        FUN = function(x) {
            currency <- set_names(x)

            if (substr(currency[[1]][1], 1, 1) == "t") {
                trading <<- trading %>%
                            dplyr::bind_rows(currency)
            } else {
                funding <<- funding %>%
                            dplyr::bind_rows(currency)
            }

            TRUE
        }
    )

    info <- list()
    info$funding <- funding
    info$trading <- trading

    info
}

#' @title Retrieve Cryptocurrency Data
#' @description Calls the Bitfinex API to retrieve cryptocurrency data
#'              for a single ticker.
#' @param SYMBOL Character ticker symbol for a single
#'               cryptocurrency. Must be prepended with a \code{t} or
#'               \code{f} to specify trading or funding
#'               cryptocurrencies, respectively.
#' @return A \code{tibble}. See details for column names.
#' @details
#' ### `tibble` descriptions:
#' * `SYMBOL`: The symbol/ticker of the requested data
#' * `FRR`: Flash Return Rate - average of all fixed rate funding over
#'          the last hour *(funding tickers only)*
#' * `BID`: Price of last highest bid
#' * `BID_PERIOD`: Bid period covered in days *(funding tickers only)*
#' * `BID_SIZE`: Sum of the 25 highest bid sizes
#' * `ASK`: Price of last lowest ask
#' * `ASK_PERIOD`: Ask period covered in days *(funding tickers only)*
#' * `ASK_SIZE`: Sum of the 25 lowest ask sizes
#' * `DAILY_CHANGE`: Amount that the last price has changed since yesterday
#' * `DAILY_CHANGE_RELATIVE`: Relative price change since yesterday
#'                           (*100 for percentage change)
#' * `LAST_PRICE`: Price of the last trade
#' * `VOLUME`: Daily volume
#' * `HIGH`: Daily high
#' * `LOW`: Daily low
#' * `FRR_AMOUNT_AVAILABLE`: The amount of funding that is available at
#'                           the Flash Return Rate *(funding tickers only)*
#' @md
#' @examples
#' \dontrun{
#'     # Get Bitcoin info
#'     ticker(SYMBOL = "tBTCUSD")
#'
#'     # Get USD info
#'     tickers(SYMBOL = "USD")
#' }
#' @export
ticker <- function(SYMBOL = "tBTCUSD") {
    bit_url <- "https://api-pub.bitfinex.com/v2/ticker/"
    query   <- paste0(bit_url, SYMBOL)

    api_call <- httr::GET(query)

    httr::stop_for_status(
        api_call,
        task = paste("get symbol", SYMBOL)
    )

    api_call <- httr::content(api_call) %>%
                purrr::prepend(SYMBOL)

    set_names(api_call)
}

#' @title Retrieve Cryptocurrency Historical Data
#' @description Calls the Bitfinex API to retrieve historical cryptocurrency
#'              records.
#' @param SYMBOLS Character vector containing ticker symbols for
#'                cryptocurrencies, or \code{ALL} for all possible tickers.
#'                Must be prepended with a \code{t} or \code{f} to specify
#'                trading or funding cryptocurrencies, respectively.
#' @param start Millisecond start time
#' @param end Millisecond end time
#' @param limit Number of records (Max 250)
#' @return A \code{tibble}. See details for column names.
#' @details
#' ### `tibble` descriptions:
#' * `SYMBOL`: The symbol/ticker of the requested data
#' * `BID`: Price of last highest bid
#' * `ASK`: Price of last lowest ask
#' * `MTS`: millisecond timestamp
#' @md
#' @examples
#' \dontrun{
#'     # Get Bitcoin and Litecoin info
#'     tickers(SYMBOLS = c("tBTCUSD", "tLTCUSD"))
#'     # Returns $trading tibble with 2 rows
#'     # and $funding tibble with 0 rows
#'
#'     # Get USD info
#'     tickers(SYMBOLS = "USD")
#'     # Return $trading tibble with 0 rows
#'     # and $funding tibble with 1 row
#' }
#' @export
ticker_history <- function(SYMBOLS = c("ALL"), start, end, limit) {
    bit_url <- "https://api-pub.bitfinex.com/v2/tickers/hist"
    query   <- paste0(bit_url,
                      "?symbols=",
                      paste(SYMBOLS, collapse = ","))

    if (!missing(start)) paste0(query, "&start=", start)

    if (!missing(end)) paste0(query, "&end=", end)

    if (!missing(limit)) {
        if (limit > 250) stop('"limit" must be <= 250 for history call.')
        paste0(query, "&limit=", limit)
    }

    api_call <- httr::GET(query)

    httr::stop_for_status(
        api_call,
        task = paste("get symbol", SYMBOLS)
    )

    api_call <- httr::content(api_call)

    if (length(api_call) == 0) {
        stop("\n\tGET request is invalid.",
             " Check query parameters for tickers_history() call with",
             " symbols:\n\t\t",
             paste(SYMBOLS, collapse = "\n\t\t"))
    }

    info <- tibble::tibble()

    lapply(
        api_call,
        FUN = function(x) {
            ticker_info <- unlist(x) %>%
                           t() %>%
                           as.data.frame() %>%
                           tibble::as_tibble() %>%
                           setNames(c("SYMBOL", "BID", "ASK", "MTS"))

            ticker_info[-1] <- ticker_info[-1] %>%
                               dplyr::mutate(
                                   dplyr::across(.fns = as.numeric)
                               )

            info <<- dplyr::bind_rows(info, ticker_info)

            TRUE
        }
    )

    info
}

#' @title Retrieve Cryptocurrency Trade Data
#' @description Calls the Bitfinex API to retrieve cryptocurrency public trade
#'              records.
#' @param SYMBOL Character vector containing ticker symbols for
#'               cryptocurrencies.
#'               Must be prepended with a \code{t} or \code{f} to specify
#'               trading or funding cryptocurrencies, respectively.
#' @param start Millisecond start time
#' @param end Millisecond end time
#' @param limit Number of records (Max 10000)
#' @return A \code{tibble}. See details for column names.
#' @details
#' ### `tibble` descriptions:
#' * `SYMBOL`: The symbol/ticker of the requested data
#' * `ID`: ID of the trade
#' * `MTS`: millisecond timestamp
#' * `AMOUNT`: 	How much was bought (positive) or sold (negative).
#' * `PRICE`: Price at which the trade was executed (trading tickers only)
#' * `RATE`: Rate at which funding transaction occurred (funding tickers only)
#' * `PERIOD`: Amount of time the funding transaction was for
#'             (funding tickers only)
#' @md
#' @examples
#' \dontrun{
#'     # Get 1000 Bitcoin trades info
#'     trades(SYMBOL = "tBTCUSD", limit = 1000)
#'
#'     # Get USD trades info
#'     trades(SYMBOL = "USD")
#' }
#' @export
trades <- function(SYMBOL = "tBTCUSD", start, end, limit) {
    query <- paste0("https://api-pub.bitfinex.com/v2/trades/",
                    SYMBOL,
                    "/hist")

    if (!missing(limit) | !missing(start) | !missing(end))
        query <- paste0(query, "?")

    if (!missing(limit)) {
        if (limit > 10000) stop('"limit" must be <= 10000 for trades call')
        query <- paste0(query, "&limit=", limit)
    }

    if (!missing(start)) query <- paste0(query, "&start=", start)
    if (!missing(end))   query <- paste0(query, "&end=",   end)

    api_call <- httr::GET(query)

    httr::stop_for_status(
        api_call,
        task = paste("get symbol", SYMBOL)
    )

    api_call <- httr::content(api_call)

    if (length(api_call) == 0) {
        stop("\n\tGET request is invalid.",
             " Check query parameters for trades() call with",
             " symbols:\n\t\t",
             paste(SYMBOL, collapse = "\n\t\t"))
    }

    info <- tibble::tibble()

    lapply(
        api_call,
        FUN = function(x) {
            trade_info <- unlist(x) %>%
                          t() %>%
                          as.data.frame() %>%
                          tibble::as_tibble() %>%
                          setNames(c("ID", "MTS", "AMOUNT",
                                     "PRICE", "RATE", "PERIOD")) %>%
                          sapply(as.numeric) %>%
                          as.data.frame() %>%
                          tibble::as_tibble() %>%
                          dplyr::mutate(SYMBOL = SYMBOL)

            info <<- dplyr::bind_rows(info, trade_info)

            TRUE
        }
    )

    info
}

## WIP ##
# Book
# Stats
# Candles
# Configs
# Status
# Liquidation Feed
# Leaderboards
# Pulse History
# Pulse Profile Details
# Funding Stats
