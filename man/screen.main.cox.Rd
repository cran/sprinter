\name{screen.main.cox}
\alias{fit.uniCox}
\alias{fit.CoxBoost}
\title{
Adaptive function for screening main effects and performing a Cox model
}
\description{
The adaptive function selects the most important main effects and performs a Cox proportional hazards model for the usage in the argument \code{screen.main} in the function \code{sprinter}.
For time-to-event data two methods are available for the screening step: Either a Cox proportional Hazards model with variable selection by adjusted univariate p-values (\code{fit.uniCox}) can be performed or a model is build via CoxBoost (\code{fit.CoxBoost}).
}

\usage{

fit.uniCox(time, status, x, unpen.index = NULL, 
             method = 'bonferroni', sig = 0.05,...)

fit.CoxBoost(time, status, x, unpen.index = NULL, 
             seed = 123, 
             stepno = NULL,
             K = 10, 
             criterion = 'pscore', 
             nu = 0.05,
             maxstepno=200,
             standardize = T, 
             trace = T, \dots)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{time}{
vector of length n specifying the observed times.}
  \item{status}{
censoring indicator, i.e., vector of length n with entries 0 for censored observations and 1 for uncensored observations.}
  \item{x}{
n * p matrix of covariates.}
  \item{unpen.index}{
vector with indices of mandatory covariates, where parameter estimation should be performed unpenalized.}
  \item{seed}{
Seed for random number generator.
}
  \item{stepno}{
number of boosting steps.
}
  \item{K}{
number of folds to be used for cross-validation. If K is larger or equal to the number of non-zero elements in status, leave-one-out cross-validation is performed.
}
  \item{criterion}{
indicates the criterion to be used for selection in each boosting step. "pscore" corresponds to the penalized score statistics, "score" to the un-penalized score statistics. Different results will only be seen for un-standardized covariates ("pscore" will result in preferential selection of covariates with larger covariance), or if different penalties are used for different covariates. "hpscore" and "hscore" correspond to "pscore" and "score". However, a heuristic is used for evaluating only a subset of covariates in each boosting step, as described in Binder et al. (2011). This can considerably speed up computation, but may lead to different results.
}
  \item{nu}{
value for evaluating the penalty for the update of an individual element of the parameter vector in each boosting step (penalty = sum(status)*(1/nu-1)).
}
  \item{maxstepno}{
maximum number of boosting steps to evaluate, i.e, the returned "optimal" number of boosting steps will be in the range [0,maxstepno].
}
  \item{standardize}{
logical value indicating whether covariates should be standardized for estimation. This does not apply for mandatory covariates, i.e., these are not standardized.
}
  \item{trace}{
logical value indicating whether progress in estimation should be indicated by printing the name of the covariate updated.
}
  \item{method}{
method for adjusting p-values. A variable is selected if its adjusted p-value is less than \code{sig}. 
}
  \item{sig}{
selection level. A variable is selected if its adjusted p-value is less than \code{sig}
}
\item{\dots}{
  further arguments passed to methods.
  }

 }


\details{
\code{fit.uniCox} and \code{fit.CoxBoost} are adapted functions for the usage of screening main effects in the function \code{\link{sprinter}} for time-to-event data.
Both approaches fit a multivariate Cox proportional hazards model.

\subsection{fit.uniCox}{
\code{fit.uniCox} fits a multivariate Cox proportional hazards model after a variable selection step. Therefore univariate Cox proportional hazard models are performed for each variable. All variables with univariate adjusted p-values less than \code{sig} are selected for the multivariate model. The variables with indices \code{unpen.index} are mandatory for the multivariate Cox model.
}

\subsection{fit.CoxBoost}{
\code{fit.CoxBoost} fits a Cox proportional hazards model by using \code{CoxBoost}. 
If the number of boosting steps is not specified in \code{stepno} the step number is evaluated by cross validation. 
See more information about fitting a Cox proportional hazards model by CoxBoost in \code{\link{CoxBoost}}.
}

\subsection{Implementing new functions for the argument \code{screen.main}}{
New functions for screening potential main effects can be implemented by the user.
Therefore, the function must be constructed in a way that a Cox proportional Hazards model is generated.
This model should be returned together with the names of the variables used in the model, called \code{xnames}, and their corresponding indices, called \code{indmain}. \cr
The following arguments must be enclosed in this function: 
\tabular{ll}{
time \tab vector of length n specifying the observed times.\cr
status \tab censoring indicator, i.e., vector of length n with entries 0 for censored observations\cr 
      \tab and 1 for uncensored observations.\cr
x \tab n * p matrix of covariates.\cr
unpen.index \tab vector with indices of mandatory covariates.
}


With this instructions the user can create new functions for screening main effects. 
To set further arguments for this function create a list of arguments, which can be quoted in args.screen.main. 
In the next step the screened main effects will be used for orthogonalizing the data by computing residuals corresponding to the selected main effects and the mandatory covariates.
}}

\value{
The adaptive function returns the following values:
\item{model}{Cox proportional Hazards model. \code{fit.uniCox} returns an object of class \code{\link{coxph}} and \code{fit.CoxBoost} returns an object of class \code{\link{CoxBoost}}.}
\item{xnames}{vector of length \code{p} containing the names of the covariates. }
\item{indmain}{vector of length \code{p} containing the indices of the selected covariates. }
\item{beta}{vector of length \code{p} containing the coefficients of the selected covariates.}

%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
}

\references{
Andersen, P. and Gill, R. (1982). Cox's regression model for counting processes, a large sample study. Annals of Statistics 10, 1100-1120.

Binder, H., Allignol, A., Schumacher, M., and Beyersmann, J. (2009). Boosting for high-dimensional time-to-event data with competing risks. Bioinformatics, 25:890-896.
}

\author{
Written by Isabell Hoffmann \email{isabell.hoffmann@uni-mainz.de}.
}


%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
\code{\link{p.adjust}}, \code{\link{coxph}}, \code{\link{CoxBoost}}
}

