\name{resample.sprinter}
\alias{resample.sprinter}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Wrapper for the function \code{sprinter} in order to judge the stability of the selected variables}
\description{
\code{resample.sprinter} is a wrapper, which subsamples the data and performs the function sprinter on each subsample. It evaluates the interaction terms by an improvement in prediction performance. The importance of an interaction is judged by variable inclusion frequencies and mean coefficients for each interaction term.
}
\usage{
resample.sprinter(x, time, 
                  status,
                  fold = 5,
                  oob.rel = 0.632,
                  mandatory,
                  repetitions = 25, 
                  n.inter.candidates = 1000, 
                  screen.main, 
                  screen.inter = fit.rf, 
                  fit.final,
                  args.screen.main = list(), 
                  args.screen.inter = list(),
                  args.fit.final = args.screen.main, 
                  orthogonalize = TRUE,
                  parallel = FALSE, 
                  mc.cores = detectCores(), \dots)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{x}{
n * p matrix of covariates.
}
  \item{time}{
vector of length \code{n} specifying the observed times.
}
  \item{status}{
censoring indicator, i.e., vector of length \code{n} with entries \code{0} for censored observations and 1 for uncensored observations.
}
  \item{fold}{
number of subsamples. Default is 5.
}
  \item{oob.rel}{
frequency of subsamples.
}
  \item{mandatory}{
vector with variable names of mandatory covariates, where parameter estimation should be performed unpenalized.
}
  \item{repetitions}{
number of repetitions of the interaction screening approach. Repetitions are performed by creating subsamples and applying the interaction screening approach on each subsample dataset separately.
}
  \item{n.inter.candidates}{
minimal number of potential interaction candidates, which are considered in the final model building step. 
}
  \item{screen.main}{
function for screening potential main effects. See more in details.
}
  \item{screen.inter}{
function for detecting potential interaction candidates. See more in details.
}
  \item{fit.final}{
function for building final Cox proportional hazards model. Default is the function set in screen.main. See more in details.
}
  \item{args.screen.main}{
list of arguments which should be used in the main effects detection step.}
  \item{args.screen.inter}{
list of arguments which should be used in the interaction screening step.}
  \item{args.fit.final}{
list of arguments which should be used in the final model building step.}
  \item{orthogonalize}{
logical value. If true all variables are made orthogonal to those that are assessed as main effects by \code{screen.main}.
  }
  \item{parallel}{
logical value indicating whether the interaction screening step should be performed parallel.
}
  \item{mc.cores}{
  the numbers of cores to use. 
  }
  \item{\dots}{
  additional arguments.
  }
}

\details{
\code{resample.sprinter} provides the possibility of evaluating the relevance of an interaction by using resampling techniques and the resultant variable inclusion frequency. 
This function  subsamples the data and applies the function \code{\link{sprinter}} on each subsample. 
As a result the user can print the interactions with the largest inclusion frequencies and their mean coefficients.
}

\value{
Returns a list of length \code{fold} of objects produced by \code{sprinter}.
}

\references{
Sariyar, M., Hoffmann, I. Binder, H. (2014). Combining techniques for screening and evaluating interaction terms on high-dimensional time-to-event data. BMC Bioinformatics 15:58.
}

\author{
Written by Isabell Hoffmann \email{isabell.hoffmann@uni-mainz.de}.
}


%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
\code{\link{sprinter}}
}

\examples{
############
# Example for resampling and screening main effects by CoxBoost, 
# screening interactions by random forest and 
# building a final Cox proportional hazards model by CoxBoost:
# system.time with one core:
#   user  system elapsed 
# 399.78    2.40  403.02 
# For a faster run set repetitions down!
############

\dontrun{
# Create survival data with interactions:
data <- simul.int(518,n = 200, p = 500,
                   beta.int = 1.0,
                   beta.main = 0.9, 
                   censparam = 1/20, 
                   lambda = 1/20)[[1]]
set.seed(123)

resamcb <- resample.sprinter(  x=data[,1:500],  
                               time = data$obs.time,
                               status= data$obs.status,
                               fold = 10,
                               repetitions = 5, 
                               mandatory = c("ID1","ID2"),
                               n.inter.candidates = 1000, 
                               screen.main = fit.CoxBoost, 
                               fit.final = fit.CoxBoost,  
                               args.screen.main = list(stepno = 5),
                               parallel = F)
summary(resamcb)
summary(resamcb, optional = T)
}
# true coefficients:
# Clin.cov1   Clin.cov2   ID5:ID6   ID7:ID8
# 0.9         -0.9        1         -1


## Example for resampling and screening main effects by CoxBoost, 
## screening interactions by random forest and 
## building a final Cox proportional hazards model by CoxBoost:
##
##system.time with one core:
##   user  system elapsed 
##  479.55    2.39  482.40  
## For a faster run set repetitions down!

\dontrun{
# Create survival data with interactions:
data <- simul.int(518,n = 200, p = 500,
                   beta.int = 1.0,
                   beta.main = 0.9, 
                   censparam = 1/20, 
                   lambda = 1/20)[[1]]

resamunicox <- resample.sprinter(  x=data[,1:500],  
                               time = data$obs.time,
                               status= data$obs.status,
                               fold = 10,
                               repetitions = 10, 
                               mandatory = c("ID1","ID2"),
                               n.inter.candidates = 1000, 
                               screen.main = fit.uniCox, 
                               fit.final = fit.uniCox,  
                               parallel = FALSE)
                               
                               
summary(resamunicox)
summary(resamunicox, optional = TRUE)

}
}

