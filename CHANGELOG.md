# Changelog

## Unreleased
### Planned
- Bitfenix:
    * [Book](https://docs.bitfinex.com/reference#rest-public-book)
    * [Stats](https://docs.bitfinex.com/reference#rest-public-stats1)
    * [Candles](https://docs.bitfinex.com/reference#rest-public-candles)
    * ...Remaining Public Endpoints
    * Calculation Endpoints
    * Authenticated Endpoints


## 0.0.2 - 2021-01-16
### Added
- Support for Bitfenix:
    * [Trades](https://docs.bitfinex.com/reference#rest-public-trades)
    * POST Authentication Helper Functions
        - `bfx_auth()` - Get Bitfenix API Keys from Env. Variables.
        - `set_bfx_auth()` - Set Bitfenix API Keys
        - `bfx_feth()` - Get Bitfenix POST headers
- Function `cryptocurr::status()` for displaying supported API statuses.

## 0.0.1 - 2021-01-15
### Added
- Initial commit and documentation.
- Current support:
    * Bitfenix
        - [Platform Status](https://docs.bitfinex.com/reference#rest-public-platform-status)
        - [Tickers](https://docs.bitfinex.com/reference#rest-public-tickers)
        - [Ticker](https://docs.bitfinex.com/reference#rest-public-ticker)
        - [Tickers History](https://docs.bitfinex.com/reference#tickers-history)