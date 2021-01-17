
# cryptocurr  <a href="https://cryptocurr.justinsingh.me"><img src="man/figures/logo.png" alt="cryptocurr logo" width=25% align="right" /></a>

<!-- badges: start -->
[![Build Status](https://travis-ci.com/program--/cryptocurr.svg?branch=master)](https://travis-ci.com/program--/cryptocurr)
[![R build status](https://github.com/program--/cryptocurr/workflows/R-CMD-check/badge.svg)](https://github.com/program--/cryptocurr/actions)
[![Codecov test coverage](https://codecov.io/gh/program--/cryptocurr/branch/master/graph/badge.svg)](https://codecov.io/gh/program--/cryptocurr)
[![Project Status: WIP – Initial development is in progress, but there has not yet been a stable, usable release suitable for the public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
<!-- badges: end -->

`cryptocurr` is an API Wrapper written in R for various cryptocurrency exchange platforms.
Built with the [`tidyverse`](https://www.tidyverse.org/) in mind, data gathered from `cryptocurr`
integrates seemlessly within the core and related universes, such as
with [`tidyquant`](https://business-science.github.io/tidyquant/) and
[`timetk`](https://business-science.github.io/timetk/).

## Installation

To install the developmental version:

```r
remotes::install_github("program--/cryptocurr")
```

## Supported Platforms
| Name | API |
| ---| --- |
| [Bitfinex](https://www.bitfinex.com/) | [v2](https://docs.bitfinex.com/reference) |

## Planned Platforms
| Name | Phase |
| --- | --- |
| [Coinbase](https://www.coinbase.com/) | ❌ Not Started  |
| [Kraken](https://www.kraken.com)      | ❌ Not Started  |
| [Binance](https://www.binance.com/)   | ❌ Not Started  |

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(cryptocurr)
## basic example code
```

## Roadmap

<img src="man/figures/cryptocurr-roadmap.png" alt="cryptocurr roadmap" align="center" />

## [Changelog](CHANGELOG.md)

## Code of Conduct
  
Please note that the cryptocurr project is released with a [Contributor Code of Conduct](https://github.com/program--/cryptocurr/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
