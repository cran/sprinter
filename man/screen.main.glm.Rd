\name{screen.main.glm}
\alias{fit.GAMBoost}
\alias{fit.uniGlm}
\title{
Adaptive function for screening main effects and fitting a generalized linear model
}
\description{
The adaptive function selects the most important main effects and fits a generalized linear model for the usage in the argument \code{screen.main} in the function \code{sprinter}.
Two methods are available for this screening step: Either a generalized linear model with variable selection by adjusted univariate p-values (\code{fit.uniGlm}) can be performed or a model is build via GAMBoost (\code{fit.GAMBoost}).
}

\usage{

fit.GAMBoost(time, status, x, unpen.index = NULL, 
             seed = 123, 
             stepno = NULL,
             penalty = 100,
             maxstepno = 200,
             standardize = T, 
             criterion = 'deviance',
             family = gaussian(),
             trace = T, \dots)
fit.uniGlm(time, status, x, unpen.index = NULL, 
              method = 'bonferroni', 
              family = gaussian(), 
              sig = 0.05, \dots)

}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{time}{
vector of length n specifying the response.}
  \item{status}{
censoring indicator. These functions are not constructed for time-to-event data. Therefore, all entities of this vector are zero.}
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
  \item{criterion}{
indicates the criterion to be used for selection in each boosting step. "pscore" corresponds to the penalized score statistics, "score" to the un-penalized score statistics. Different results will only be seen for un-standardized covariates ("pscore" will result in preferential selection of covariates with larger covariance), or if different penalties are used for different covariates. "hpscore" and "hscore" correspond to "pscore" and "score". However, a heuristic is used for evaluating only a subset of covariates in each boosting step, as described in Binder et al. (2011). This can considerably speed up computation, but may lead to different results.
}
  \item{maxstepno}{
maximum number of boosting steps to evaluate, i.e, the returned "optimal" number of boosting steps will be in the range [0,maxstepno].
}
  \item{standardize}{
logical value indicating whether covariates should be standardized for estimation. This does not apply for mandatory covariates, i.e., these are not standardized.
}
  \item{penalty}{
  penalty value for the update of an individual smooth function in each boosting step.
}
  \item{family}{
  a description of the error distribution. This can be a character string naming a family function, a family function or the result of a call to a family function.
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
\code{fit.uniGlm} and \code{fit.GAMBoost} are adapted as functions for the usage of screening main effects in the function \code{\link{sprinter}}.
Both approaches fit a generalized linear model.

\subsection{fit.uniGlm}{
\code{fit.uniCox} fits a generalized linear regression model after a variable selection step. Therefore univariate regression models are performed for each variable. All variables with univariate adjusted p-values less than \code{sig} are selected for the multivariate model. The variables with indices \code{unpen.index} are mandatory for the multivariate regression model.
}

\subsection{fit.GAMBoost}{
\code{fit.GAMBoost} fits a generalized regression model by using \code{GAMBoost}. 
If the number of boosting steps is not specified in \code{stepno} the step number is evaluated by cross validation. 
See more information about fitting a generalized regression model by GAMBoost in \code{\link{GAMBoost}}.
}

\subsection{Implementing new functions for the argument \code{screen.main}}{
New functions for screening potential main effects can be implemented by the user.
Therefore, the function must be constructed in a way that a generalized linear model is generated.
This model should be returned together with the names of the variables used in the model, called \code{xnames}, and their corresponding indices, called \code{indmain}. \cr
The following arguments must be enclosed in this function: 
\tabular{ll}{
time \tab vector of length n specifying the outcome.\cr
status \tab censoring indicator, which is always NULL in the case fitting a generalized linear models\cr 
x \tab n * p matrix of covariates.\cr
unpen.index \tab vector with indices of mandatory covariates.
}


With this instructions the user can create new functions for screening main effects. 
To set further arguments for this function create a list of arguments, which can be quoted in args.screen.main. 
In the next step the screened main effects will be used for orthogonalizing the data by computing residuals corresponding to the selected main effects and the mandatory covariates.
}}

\value{
The adaptive function returns the following values:
\item{model}{Generalized linear model. \code{fit.uniGlm} returns an object of class \code{\link{glm}} and \code{fit.GAMBoost} returns an object of class \code{\link{GAMBoost}}.}
\item{xnames}{vector of length \code{p} containing the names of the covariates. }
\item{indmain}{vector of length \code{p} containing the indices of the selected covariates. }
\item{beta}{vector of length \code{p} containing the coefficients of the selected covariates.}

%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
}


\author{
Written by Isabell Hoffmann \email{isabell.hoffmann@uni-mainz.de}.
}


%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
\code{\link{p.adjust}}, \code{\link{glm}}, \code{\link{GAMBoost}}
}

