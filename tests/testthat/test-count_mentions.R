test_that("Word counts work", {
  # sheep tests word boundaries
  # cow tests capitalization
  text_to_search <- "Cow cow pig Horsesheep sheep cow sheeppig"
  search1 <- count_word_mentions(text_to_search, c("cow", "sheep"), TRUE)
  search2 <- count_word_mentions(text_to_search, c("cow", "sheep"), FALSE)
  expect_equal(search1$mentions[search1$word == "cow"], 3L)
  expect_equal(search2$mentions[search1$word == "cow"], 2L)
  expect_equal(search1$mentions[search1$word == "sheep"], 1L)
  expect_true(inherits(search1, "data.frame"))
  expect_equal(nrow(search2), 2L)
  expect_named(search1, c("mentions", "word"))
})

test_that("Multi-word word counts work", {
  text_to_search <- "Pigs are very smart animals, extremely smart animals"
  search1 <- count_word_mentions(
    text_to_search,
    c("very smart", "smart animals"),
    TRUE
  )
  expect_equal(search1$mentions[search1$word == "very smart"], 1L)
  expect_equal(search1$mentions[search1$word == "smart animals"], 2L)
  expect_true(inherits(search1, "data.frame"))
  expect_equal(nrow(search1), 2L)
  expect_named(search1, c("mentions", "word"))
})

test_that("String counts work", {
  # sheep tests word boundaries
  # cow tests capitalization
  text_to_search <- "Cow cow pig Horsesheep sheep cow sheeppig"
  search1 <- count_text_mentions(text_to_search, c("cow", "sheep"), TRUE)
  search2 <- count_text_mentions(text_to_search, c("cow", "sheep"), FALSE)
  expect_equal(search1$mentions[search1$word == "cow"], 3L)
  expect_equal(search2$mentions[search1$word == "cow"], 2L)
  expect_equal(search1$mentions[search1$word == "sheep"], 3L)
  expect_true(inherits(search1, "data.frame"))
  expect_equal(nrow(search2), 2L)
  expect_named(search1, c("mentions", "word"))
})


test_df <- data.frame(
  rownum = 1:3,
  text = c(
    "Cow cow pig Horsesheep sheep cow sheeppig",
    "Pig sheep",
    "horse"
  )
)
words_to_find <- c("cow", "sheep", "pig")

test_that("word count over data frame works: don't return all rows", {
  count_df <- count_mentions_in_dataframe(test_df, words_to_find, T, T, F)
  expect_true(inherits(count_df, "data.frame"))
  expect_equal(unique(count_df$rownum), c(1, 2)) # row 3 had no matches
  expect_equal(as.character(count_df$word), rep(words_to_find, 2))
  expect_equal(count_df$mentions, c(3, 1, 1, 0, 1, 1))
})

test_that("word count over data frame works: return all rows", {
  count_df <- count_mentions_in_dataframe(test_df, words_to_find, T, T, T)
  expect_true(inherits(count_df, "data.frame"))
  expect_equal(unique(count_df$rownum), c(1, 2, 3))
  expect_equal(as.character(count_df$word), rep(words_to_find, 3))
  expect_equal(count_df$mentions, c(3, 1, 1, 0, 1, 1, 0, 0, 0))
})

test_that("word count over data frame works: case sensitive", {
  count_df <- count_mentions_in_dataframe(test_df, words_to_find, F, T, F)
  expect_true(inherits(count_df, "data.frame"))
  expect_equal(count_df$mentions, c(2, 1, 1, 0, 1, 0))
})

test_that("word count over data frame works: no word boundaries", {
  count_df <- count_mentions_in_dataframe(test_df, words_to_find, T, F, F)
  expect_true(inherits(count_df, "data.frame"))
  expect_equal(count_df$mentions, c(3, 3, 2, 0, 1, 1))
})

test_that("multi-word count works ok", {
  words_to_find <- c("cow pig", "sheep cow", "sheep sheep")
  count_df <- count_mentions_in_dataframe(test_df, words_to_find, T, T, F)
  expect_true(inherits(count_df, "data.frame"))
  expect_equal(count_df$mentions, c(1, 1, 0))
})
