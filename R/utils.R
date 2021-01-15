#' Pipe operator
#'
#' See \code{magrittr::\link[magrittr:pipe]{\%>\%}} for details.
#'
#' @name %>%
#' @rdname pipe
#' @keywords internal
#' @export
#' @importFrom magrittr %>%
#' @usage lhs \%>\% rhs
NULL

## usethis namespace: start
#' @importFrom tibble tibble
## usethis namespace: end
NULL

set_names <- function(ticker_info_get) {
    ticker_info <- unlist(ticker_info_get) %>%
                   t() %>%
                   as.data.frame() %>%
                   tibble::as_tibble()

    ticker_info[-1] <- ticker_info[-1] %>%
                       mutate(across(.fns = as.numeric))

    if (substr(ticker_info[[1]][1], start = 1, stop = 1) == "t") {
        ticker_info <- setNames(
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
        ticker_info <- setNames(
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