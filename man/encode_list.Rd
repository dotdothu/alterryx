% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/signature.R
\name{encode_list}
\alias{encode_list}
\title{Percent encode all values in a list using \code{utils::URLencode}}
\usage{
encode_list(l, reserved = TRUE, repeated = TRUE)
}
\arguments{
\item{l}{A \code{list}}

\item{reserved}{logical: should ‘reserved’ characters be encoded?}

\item{repeated}{logical: should apparently already-encoded URLs be encoded
again?}
}
\description{
Percent encode all values in a list using \code{utils::URLencode}
}
