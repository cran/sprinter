\name{screen.inter}
\alias{fit.logicReg}
\alias{fit.logicReg.select}
\alias{fit.rf}
\alias{fit.rf.select}
\title{
Adaptive function for screening interactions}
\description{
\code{fit.logicReg} and \code{fit.rf} are functions for screening interactions in high-dimensional datasets for the usage in the argument \code{screen.inter} in the function \code{sprinter}.
They return a variable importance measurement for each variable.
}
\usage{
fit.rf(nr, data, indices, seed.interselect, \dots)

fit.rf.select(nr, data, indices, seed.interselect, n.select, \dots)

fit.logicReg(nr, data, indices, seed.interselect,
       type,
       nleaves,
       ntrees, \dots)
fit.logicReg.select(nr, data, indices, seed.interselect,
       type,
       nleaves,
       ntrees, 
       n.select,\dots)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{nr}{
  number of resample run.
}
  \item{data}{
  data frame containing the y-outcome and x-variables in the model, which is orthogonalized to the clinical covariates and the main effects identified in the main effects detection step.
}
  \item{indices}{
indices to build the resample dataset.
}
  \item{seed.interselect}{
seed for random number generator.
}
  \item{n.select}{
Number of variables selected for performing random forest.
}
  \item{type}{type of model to be fit. For survival data you can choose between (4) proportional hazards model (Cox regression), and (5) exponential survival model, or (0) your own scoring function. }
  \item{nleaves}{maximum number of leaves to be fit in all trees combined. }
  \item{ntrees}{number of logic trees to be fit.}
  \item{\dots}{
  further arguments passed to methods.
}
}


\details{
The functions \code{logicReg} and \code{fit.rf} are adapted for the usage in the function sprinter in order to screen interactions.
Therein, variable importance measurements are evaluated for each variable, which will be used for pre-selecting relevant interactions in the function \code{\link{sprinter}}.
In thefunction \code{sprinter} the identified interaction candidates will be combined with each other pairwise and will be provided as possible predictors for the final model. 

\subsection{fit.rf}{
This function performs a random forest for survival. 
It judges each variable by the permutation accuracy importance.
For more information about performing the random forest see \code{\link{rfsrc}}.
}

\subsection{fit.rf.select}{
This function performs a random forest for survival on a restricted data set. 
The number of covariables in this restricted data set can be set in \code{n.select}.
The variables with the \code{n.select} smallest univariate p-values evaluated by Cox regression are selected.
}

\subsection{fit.logicReg}{
For the usage of the logic regression all continuous variables are converted to binary variables at the median.
Then the logic regression is fitted onto the binary data set.
The variable importance measure is one, if the variable is included in the model and zero if not.
In order to get the information about the variables in a multiple model, the set \code{select = 2} is obligatory.
}

\subsection{fit.logicReg.select}{
This function performs logic regression on a restricted data set. 
The number of covariables in this restricted data set can be set in \code{n.select}.
The variables with the \code{n.select} smallest univariate p-values evaluated by Cox regression are selected.
}

\subsection{Implementing new functions for the argument \code{screen.inter}}{
New functions for screening interactions can be constructed in a way that for each variable an importance measurement is returned as a vector of length \code{p}. The variable importance measurements larger than zero should be interpreted as relevant for the model. \cr
The following arguments must be enclosed in this function: 
\tabular{ll}{
nr \tab value displaying the actual resampling run.\cr
data \tab data frame containing the y-outcome and x-variables in the model.\cr
indices \tab indices to build the resample dataset.\cr
seed.interselect \tab seed for random number generator.
}

With this directive other functions can be implemented and used for screening potential interaction candidates. 
}

}


\value{
\code{fit.rf} and \code{fit.logicReg} return a vector of length p, containing the variable importance of each variable in the data set.

\code{fit.rf} evaluates the permutation accuracy importance (PAM) as a measure for the variable importance. The function \code{fit.logicReg} returns the information whether a variable is enclosed in the model (1) or not (0).
}

\references{
Ruczinski I, Kooperberg C, LeBlanc ML (2003). Logic Regression, Journal of Computational and Graphical Statistics, 12, 475-511.

Breiman L. (2001). Random forests, Machine Learning, 45:5-32.

}

\author{
Written by Isabell Hoffmann \email{isabell.hoffmann@uni-mainz.de}.}



\seealso{
\code{\link{logreg}}, \code{\link{rfsrc}}
}

