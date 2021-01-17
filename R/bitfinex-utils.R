#' Get Bitfenix API Keys
#'
#' @keywords internal
#' @export
bfx_auth <- function() {
    auth <- Sys.getenv("BFX_APIKEY")
    if (identical(auth, "")) {
        stop("Please set env var BFX_APIKEY to your Bitfinex API auth key",
             call. = FALSE)
    }
    secret <- Sys.getenv("BFX_SECRET")
    if (identical(secret, "")) {
        stop("Please set env var BFX_SECRET to your Bitfinex API secret key",
             call. = FALSE)
    }

    bfx_keys        <- list()
    bfx_keys$auth   <- auth
    bfx_keys$secret <- secret

    bfx_keys
}

#' @title Set Bitfenix API Keys
#' @param API_KEY Bitfenix API key
#' @param API_SECRET Bitfenix API Secret key
#' @return `TRUE` if keys were set.
#' @export
set_bfx_auth <- function(API_KEY, API_SECRET) {
    if (missing(API_KEY) | missing(API_SECRET))
        stop("set_bfx_auth() requires both API_KEY and API_SECRET.")

    Sys.setenv(
        BFX_APIKEY = API_KEY,
        BFX_SECRET = API_SECRET
    )
    cat(
        "BFX_APIKEY set to:\n\t", API_KEY, "\n",
        "BFX_SECRET set to:\n\t", API_SECRET, "\n"
    )

    TRUE
}

#' @title Get Bitfenix POST Headers
#' @param body a `list` containing the POST body.
#' @return A `list` containing POST headers. See details.
#' @details
#' * `api_key`: User's Bitfenix API key.
#' * `nonce`: The cryptographic nonce used. Generated via: (System time * 1000)
#' * `body`: The JSON stringify'd POST body passed to the function.
#' * `signature`: The authentication signature hashed with your API secret key.
#' @md
#' @keywords internal
#' @importFrom jsonlite toJSON
#' @importFrom openssl sha384
#' @export
bfx_fetch <- function(body) {
    api_key    <- bfx_auth()$auth
    api_secret <- bfx_auth()$secret
    nonce      <- as.character(as.numeric(Sys.time()) * 1000)
    auth_sig   <- paste0(
        nonce,
        jsonlite::toJSON(body)
    )

    signature  <- openssl::sha384(
        x = auth_sig,
        key = api_secret
    )

    fetch <- list()
    fetch$api_key   <- api_key
    fetch$nonce     <- nonce
    fetch$body      <- body
    fetch$signature <- signature
}

#' @title Set ticker tibble colnames (Bitfenix)
#' @description See \code{\link{ticker}} and \code{\link{tickers}}.
#' @keywords internal
#' @importFrom stats setNames
#' @export
set_names <- function(ticker_info_get) {
    ticker_info <- unlist(ticker_info_get) %>%
                   t() %>%
                   as.data.frame() %>%
                   tibble::as_tibble()

    ticker_info[-1] <- ticker_info[-1] %>%
                       dplyr::mutate(
                           dplyr::across(.fns = as.numeric)
                       )

    if (substr(ticker_info[[1]][1], start = 1, stop = 1) == "t") {
        ticker_info <- stats::setNames(
            ticker_info,
            c("SYMBOL",
              "BID",
              "BID_SIZE",
              "ASK",
              "ASK_SIZE",
              "DAILY_CHANGE",
              "DAILY_CHANGE_RELATIVE",
              "LAST_PRICE",
              "VOLUME",
              "HIGH",
              "LOW")
        )
    } else {
        ticker_info <- stats::setNames(
            ticker_info,
            c("SYMBOL",
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
              "FRR_AMOUNT_AVAILABLE")
        )
    }

    ticker_info
}
