#' @title Get API status for supported platforms
#' @return Console output describing the status of each
#'         supported API with either "GOOD" or "BAD".
#' @examples
#' \dontrun{
#'     cryptocurr::status()
#'
#'     # OUTPUT:
#'     # cryptocurr
#'     # ===============
#'     # BITFENIX GOOD
#'     # COINBASE BAD
#'     # KRAKEN   BAD
#'     # BINANCE  BAD
#' }
#' @export
status <- function() {
    bfx_status <- dplyr::if_else(
        identical(get_status(), "Operative"),
        "GOOD",
        "BAD"
    )

    cnb_status <- "BAD" # TODO
    kkn_status <- "BAD" # TODO
    bin_status <- "BAD" # TODO

    cat(
        "cryptocurr",
        "\n===============",
        "\nBITFENIX", bfx_status,
        "\nCOINBASE", cnb_status,
        "\nKRAKEN  ", kkn_status,
        "\nBINANCE ", bin_status,
        "\n"
    )
}
