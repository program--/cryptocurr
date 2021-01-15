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
#' @param symbols Character vector containing ticker symbols for
#'                cryptocurrencies, or \code{ALL} for all possible tickers.
#'                Must be appended with a \code{t} or \code{f} to specify
#'                trading or funding cryptocurrencies, respectively.
#' @return A \code{list} with \code{tibble} attributes:
#'         \code{funding} and \code{trading}. See details.
#' @details 
#' ### `tibble` descriptions:
#' * `SYMBOL`: The symbol of the requested ticker data
#' * `FRR`: Flash Return Rate - average of all fixed rate funding over the last hour *(funding tickers only)*
#' * `BID`: Price of last highest bid
#' * `BID_PERIOD`: Bid period covered in days *(funding tickers only)*
#' * `BID_SIZE`: Sum of the 25 highest bid sizes
#' * `ASK`: Price of last lowest ask
#' * `ASK_PERIOD`: Ask period covered in days *(funding tickers only)*
#' * `ASK_SIZE`: Sum of the 25 lowest ask sizes
#' * `DAILY_CHANGE`: Amount that the last price has changed since yesterday
#' * `DAILY_CHANGE_RELATIVE`: Relative price change since yesterday (*100 for percentage change)
#' * `LAST_PRICE`: Price of the last trade
#' * `VOLUME`: Daily volume
#' * `HIGH`: Daily high
#' * `LOW`: Daily low
#' * `FRR_AMOUNT_AVAILABLE`: The amount of funding that is available at the Flash Return Rate *(funding tickers only)*
#' @md
#' @examples
#' \dontrun{
#'     # Get Bitcoin and Litecoin info
#'     tickers(symbols = c("tBTCUSD", "tLTCUSD"))
#'     # Returns $trading tibble with 2 rows
#'     # and $funding tibble with 0 rows
#'
#'     # Get USD info
#'     tickers(symbols = "USD")
#'     # Return $trading tibble with 0 rows
#'     # and $funding tibble with 1 row
#' }
#' @export
tickers <- function(symbols = c("ALL")) {
    bit_url <- "https://api-pub.bitfinex.com/v2/tickers"
    query   <- paste0(bit_url,
                      "?symbols=",
                      paste(symbols, collapse = ","))

    api_call <- httr::GET(query)

    httr::stop_for_status(
        api_call,
        task = paste("get symbol", symbol)
    )

    api_call <- httr::content(api_call)

    if (length(api_call) == 0) {
        stop("\n\tSymbols are invalid:\n\t\t",
             paste(symbols, collapse = "\n\t\t"))
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

# Ticker
ticker <- function(symbol = "tBTCUSD") {
    bit_url <- "https://api-pub.bitfinex.com/v2/ticker/"
    query   <- paste0(bit_url, symbol)

    api_call <- httr::GET(query)

    httr::stop_for_status(
        api_call,
        task = paste("get symbol", symbol)
    )

    api_call <- httr::content(api_call) %>%
                purrr::prepend(symbol)

    set_names(api_call)
}

# Tickers History
ticker_history <- function(symbols = c("ALL"), start, end, limit) {
    bit_url <- "https://api-pub.bitfinex.com/v2/tickers/hist"
    query   <- paste0(bit_url,
                      "?symbols=",
                      paste(symbols, collapse = ","))

    if (!missing(start)) paste0(query, "&start=", start)

    if (!missing(end)) paste0(query, "&end=", end)

    if (!missing(limit)) {
        if (limit > 250) stop('"limit" must be <= 250.')
        paste0(query, "&limit=", limit)
    }

    api_call <- httr::GET(query)

    httr::stop_for_status(
        api_call,
        task = paste("get symbol", symbol)
    )

    api_call <- httr::content(api_call)

    if (length(api_call) == 0) {
        stop("\n\tGET request is invalid.",
             " Check query parameters for tickers_history() call with",
             " symbols:\n\t\t",
             paste(symbols, collapse = "\n\t\t"))
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
                               mutate(across(.fns = as.numeric))

            info <<- dplyr::bind_rows(info, ticker_info)

            TRUE
        }
    )

    info
}

# Trades

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