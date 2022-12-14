% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/count_mentions.R
\name{count_text_mentions}
\alias{count_text_mentions}
\title{Count occurrences of each of a vector of words in a vector of texts}
\usage{
count_text_mentions(text, words, ignore_case = TRUE)
}
\arguments{
\item{text}{vector of character string to search for key words}

\item{words}{vector of key terms to look for}

\item{ignore_case}{should case (capital letters) be considered in matching?}
}
\description{
This helper function, combined with e.g. purrr, makes it easier to count how
often each word in a vector of words occurs within a vector of character
strings. Ignores word boundaries, optionally considers letter case.
}
