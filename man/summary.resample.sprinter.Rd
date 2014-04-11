\name{summary.resample.sprinter}
\alias{summary.resample.sprinter}
\title{Generates a summary for objects of class \code{resample.sprinter}}
\description{
Shows the interactions with the largest variable inclusion frequencies together with its mean coefficients and plots the mean coefficient of each variable against its single coefficients.
}
\usage{
\method{summary}{resample.sprinter}(object, print = TRUE, plot = TRUE, optional.only = FALSE, threshold.vif = 0, \ldots)
}
\arguments{
\item{object}{Object of class \code{\link{resample.sprinter}}.}
\item{print}{logical value. If true, a list of interactions with the largest inclusion frequencies together with its mean coefficients is shown.}
\item{plot}{logical value. If true, the mean coefficients for each selected covariate are plotted against its single coefficients.}
\item{optional.only}{logical value. If true, only the coefficients of the optional variables are plotted. If false, the coefficients of the mandatory variables are plotted as well.}
\item{threshold.vif}{only the coefficients with inclusion frequencies larger than \code{threshold.vif} are plotted.}
\item{\ldots}{additional arguments.}
}


\seealso{
\code{\link{resample.sprinter}}

}

\author{
Isabell Hoffmann \email{isabell.hoffmann@uni-mainz.de}
}

