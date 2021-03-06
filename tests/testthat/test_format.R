context("Test data formatting")

library(Synth)
data(basque)
basque <- basque %>% mutate(trt = case_when(year < 1975 ~ 0,
                                            regionno != 17 ~0,
                                            regionno == 17 ~ 1)) %>%
    filter(regionno != 1)
                            
test_that("format_data creates matrices with the right dimensions", {
    
    dat <- format_data(quo(gdpcap), quo(trt), quo(regionno), quo(year),1975, basque)

    test_dim <- function(obj, d) {
        expect_equivalent(dim(obj), d)
        }

    test_dim(dat$X, c(17, 20))
    expect_equivalent(length(dat$trt), 17)
    test_dim(dat$y, c(17, 23))
}
)


test_that("format_synth creates matrices with the right dimensions", {
    
    dat <- format_data(quo(gdpcap), quo(trt), quo(regionno), quo(year),1975, basque)
    syn_dat <- format_synth(dat$X, dat$trt, dat$y)
    test_dim <- function(obj, d) {
        expect_equivalent(dim(obj), d)
        }

    test_dim(syn_dat$Z0, c(20, 16))
    test_dim(syn_dat$Z1, c(20, 1))

    test_dim(syn_dat$Y0plot, c(43, 16))
    test_dim(syn_dat$Y1plot, c(43, 1))

    expect_equivalent(syn_dat$Z1, syn_dat$X1)
    expect_equivalent(syn_dat$Z0, syn_dat$X0)
}
)
