#' Count occurrences of each of a vector of words in a vector of texts
#'
#' This helper function, combined with e.g. purrr, makes it easier to count how
#' often each word in a vector of words occurs within a vector of character
#' strings. Considers word boundaries, optionally considers letter case.
#'
#' @param text vector of character string to search for key words
#' @param words vector of key terms to look for
#' @param ignore_case should case (capital letters) be considered in matching?
#' @export

count_word_mentions <- function(text, words, ignore_case = TRUE) {
  setNames(
    stack(
      vapply(
        words,
        function(x) {
          suppressWarnings(
            sum(
              str_count(text, regex(padb(x), ignore_case))
            )
          )
        },
        FUN.VALUE = numeric(1)
      )
    ),
    c("mentions", "word")
  )
}

#' Pad word so regex searches for word boundaries
#'
#' @param word word (or string) to pad

padb <- function(word){
  paste0("\\b", word, "\\b")
}

#' Count occurrences of each of a vector of words in a vector of texts
#'
#' This helper function, combined with e.g. purrr, makes it easier to count how
#' often each word in a vector of words occurs within a vector of character
#' strings. Ignores word boundaries, optionally considers letter case.
#'
#' @param text vector of character string to search for key words
#' @param words vector of key terms to look for
#' @param ignore_case should case (capital letters) be considered in matching?
#' @export

count_text_mentions <- function(text, words, ignore_case = TRUE) {
  setNames(
    stack(
      vapply(
        words,
        function(x) {
          suppressWarnings(
            sum(
              str_count(text, regex(x, ignore_case))
            )
          )
        },
        FUN.VALUE = numeric(1)
      )
    ),
    c("mentions", "word")
  )
}



#' Count number of occurrences key words in a text column of a data frame
#'
#' @param dataframe data frame, with a column called `"text"`
#' @param words vector of key words to search for
#' @param ignore_case logical, should case sensitivity be considered?
#' @param word_boundaries logical, should word boundaries be considered?
#' @param return_all_rows logical, return all rows, or only rows with 1+
#'   instance? It's considerably faster to only return rows with 1+ instance for
#'   large data frames and/or infrequent words.
#' @export

count_mentions_in_dataframe <- function(
  dataframe,
  words,
  ignore_case = TRUE,
  word_boundaries = TRUE,
  return_all_rows = FALSE
) {
  if (word_boundaries) {
    f_count <- count_word_mentions
    f_pad <- padb
  } else {
    f_count <- count_text_mentions
    f_pad <- function(x) x
  }
  if (!return_all_rows) {
    searchstring <- paste0(f_pad(words), collapse = "|")
    idx <- grepl(searchstring, dataframe$text, ignore.case = ignore_case)
    dataframe <- dataframe[idx, ]
  }

  dataframe$mentions <- purrr::map(dataframe$text, f_count, words, ignore_case)
  tidyr::unnest(dataframe, .data$mentions)
}
