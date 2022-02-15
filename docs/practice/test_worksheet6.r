library(digest)
library(palmerpenguins)
library(stringr)
library(testthat)

test_1 <- function(){
    test_that("mpg_to_kml should be a function", {
        expect_true(is.function(mpg_to_kml))
    })
    test_that('mpg_to_kml should use the conversion 1 mile per gallon == 0.425144 kilometres per litre', {
        expect_equal(mpg_to_kml(1), 0.425144)
        expect_equal(mpg_to_kml(2), 0.850288)
        expect_equal(mpg_to_kml(10), 4.25144)
    })
    print("success!")
}

test_2 <- function(){
    test_that('errors should be thrown when non-numeric vectors, lists or data frames are given to the mpg_to_kml function', {
        expect_error(mpg_to_kml("A"))
        expect_error(mpg_to_kml(list(1, 2)))
        expect_error(mpg_to_kml(data.frame(x = c(1))))
    })
    print("success!")
}

test_4 <- function() {
    fun_body <- paste(deparse(body(get_rectangle)), collapse = "")
    answer <- get_rectangle(penguins, body_mass_g > 3000, species:island)
    answer2 <- get_rectangle(penguins, body_mass_g > 3000)
    expect_true(is.data.frame(answer))
    expect_equal(nrow(answer), 331)
    expect_equal(ncol(answer), 2)
    expect_equal(paste(tolower(sort(colnames(answer))), collapse = ""), 'islandspecies')
    expect_equal(nrow(answer2), 331)
    expect_equal(ncol(answer2), 8)
    expect_equal(paste(tolower(sort(colnames(answer2))), collapse = ""), 'bill_depth_mmbill_length_mmbody_mass_gflipper_length_mmislandsexspeciesyear')
    expect_true(str_detect(fun_body, "\\{[ ]*\\{[ ]*row_filter[ ]*\\}[ ]*\\}"))
    expect_true(str_detect(fun_body, "\\{[ ]*\\{[ ]*column_range[ ]*\\}[ ]*\\}"))
}

test_5 <- function() {
    fun_body <- paste(deparse(body(nest_and_count)), collapse = "")
    answer <- nest_and_count(penguins, species)
    expect_true(is.data.frame(answer))
    expect_equal(nrow(answer), 3)
    expect_equal(ncol(answer), 3)
    expect_equal(paste(tolower(sort(colnames(answer)[1:2])), collapse = ""), 'dataspecies')
    expect_equal(sum(as.numeric(answer[[3]])), 344)
    expect_true(str_detect(fun_body, ":="))
}