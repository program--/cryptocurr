test_that("API Keys can be set with set_bfx_auth()", {
    expect_error(set_bfx_auth())
    Sys.unsetenv("BFX_APIKEY")
    Sys.unsetenv("BFX_SECRET")
    expect_true(
        set_bfx_auth(
            API_KEY = "test_api_key",
            API_SECRET = "test_secret_key",
            suppress = TRUE
        )
    )

    expect_output(
        set_bfx_auth(
            API_KEY = "test_api_key",
            API_SECRET = "test_secret_key"
        )
    )

    expect_equal(Sys.getenv("BFX_APIKEY")[1], "test_api_key")
    expect_equal(Sys.getenv("BFX_SECRET")[1], "test_secret_key")
    Sys.unsetenv("BFX_APIKEY")
    Sys.unsetenv("BFX_SECRET")
})

test_that("API Keys can be retrieved with bfx_auth()", {
    Sys.unsetenv("BFX_APIKEY")
    Sys.unsetenv("BFX_SECRET")
    expect_error(bfx_auth())
    Sys.setenv(BFX_APIKEY = "test_api_key")
    expect_error(bfx_auth())
    Sys.setenv(BFX_SECRET = "test_secret_key")
    expect_type(bfx_auth(), "list")
    expect_equal(bfx_auth()$auth, "test_api_key")
    expect_equal(bfx_auth()$secret, "test_secret_key")
    Sys.unsetenv("BFX_APIKEY")
    Sys.unsetenv("BFX_SECRET")
})
