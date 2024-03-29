% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/zscores_NHANES3.R
\name{zscore_NHANES3}
\alias{zscore_NHANES3}
\title{Convert spirometric values to z-scores using NHANES III equations}
\usage{
zscore_NHANES3(
  age,
  height,
  gender = 1,
  ethnicity = 1,
  FEV1 = NULL,
  FVC = NULL,
  FEV1FVC = NULL,
  PEF = NULL,
  FEF2575 = NULL,
  FEV6 = NULL,
  FEV1FEV6 = NULL
)
}
\arguments{
\item{age}{Age in years}

\item{height}{Height in meters}

\item{gender}{Gender (1 = male, 2 = female) or a factor with two levels (first = male). Default is 1.}

\item{ethnicity}{Ethnicity (1 = Caucasian, 2 = African-American, 
3 = Mexican-American). Default is 1.}

\item{FEV1}{Forced Expiratory Volume in 1 second (lt)}

\item{FVC}{Forced Vital Capacity (lt)}

\item{FEV1FVC}{FEV1 / FVC ratio}

\item{PEF}{Peak Expiratory Flow (lt)}

\item{FEF2575}{Forced Expiratory Flow between 25\% and 75\% of FVC (lt/s)}

\item{FEV6}{Forced Expiratory Volume in 6 seconds (lt)}

\item{FEV1FEV6}{FEV1 / FEV6 ratio}
}
\value{
If only one spirometry argument is supplied, the function
returns a numeric vector. If more are supplied, the function returns
a data.frame with the same number of columns.
}
\description{
This function takes absolute spirometry measurements (FEV1, FVC, etc)
in lt plus demographic data (age, height, gender and ethnicity) and converts
them to z-scores based on the NHANES III equations.
}
\details{
At least one of the spirometric measurement arguments must be set (i.e. be
non-\code{NULL}). Arguments \code{age}, \code{height}, \code{gender} and
\code{ethnicity} must be vectors of length equal to the length of the
spirometric measurement vector(s), or of length one, in which case their
value is recycled. If any input vector is not of equal length, the function
stops with an error.

Normal distributions are assumed for all parameters, even though per the NHANES III 
equations paper (\href{https://www.atsjournals.org/doi/10.1164/ajrccm.159.1.9712108}{Hankinson et al})
this was observed only for FEV1, FVC, PEF and FEV6.
}
\examples{
# Random data, 4 patients, one parameter supplied (FEV1)
zscore_NHANES3(age=seq(25,40,4), height=c(1.8, 1.9, 1.75, 1.85),
      gender=c(2,1,2,1), ethnicity=rep(1,4), FEV1=c(3.5, 4, 3.6, 3.9))

}
