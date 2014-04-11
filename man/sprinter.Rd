\name{sprinter}
\alias{sprinter}

\title{
Main function for building prognostic models by considering interactions.}
\description{
The function \code{sprinter} builds a prognostic model by preselecting interactions and main effects before fitting a regression model.}
\usage{
sprinter(x, 
         time, 
         status= rep(0, nrow(x)),
         mandatory= NULL,
         repetitions = 25, 
         n.inter.candidates =1000, 
         screen.main, 
         screen.inter = fit.rf,
         fit.final = screen.main, 
         args.screen.main = list(), 
         args.screen.inter = list(),
         args.fit.final = args.screen.main, 
         orthogonalize = TRUE, cutoff = 0,
         parallel = FALSE, mc.cores = detectCores(),
         \dots)
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
censoring indicator, i.e., vector of length \code{n} with entries \code{0} for censored observations and 1 for uncensored observations. This optional argument is neccessary in time-to-event data.
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
function for screening potential main effects. \code{fit.uniCox} performs univariate Cox-regressions and selects the main effects by their adjusted p-values. \cr \code{fit.CoxBoost} performs a variable selection by fitting a Cox model by likelihood based boosting. Other methods are possible to be implemented as adaptive functions for the usage in \code{sprinter}. For more details see \code{\link{fit.uniCox}}
}
  \item{screen.inter}{
function for detecting potential interaction candidates. \code{fit.rf} performs a random forest and \code{fit.logicReg} performs a logic regression. Other methods are possible to implement as adaptive functions for the use in \code{sprinter}. For more details see \code{\link{fit.rf}}.
}
  \item{fit.final}{
function for building the final Cox proportional hazards model. Default is the function set in screen.main. 
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
  \item{cutoff}{
value or function to evaluate a value according to the variable importance. The cutoff is used to select variables for evaluating the pairwise inclusion frequencies.
  }
  \item{parallel}{
logical value indicating whether the interaction screening step should be performed parallel.
}
\item{mc.cores}{
  the numbers of cores to use, if parallel = TRUE. 
  }
  \item{\dots}{
  additional arguments.
  }

}
\details{
A call to the \code{sprinter}-function fits a prognostic model to time-to-event data by combining available statistical components.
The modular structure secures the simultaneously consideration of two important elements in a model: interactions and main effects. \cr
Interactions play an important role in molecular applications, 
because some effects arises only if two genes are differentially expressed at the same time. 
Therefore, it is important to consider interaction terms when predicting a clinical outcome. 
The method which is used to preselect interactions is set in \code{screen.inter}.\cr
The interactions are preselected with respect to potential main effects. 
Therefore, a main effects model is performed for extracting the existing main effects and to be able to compare the main effects model with the final model to show the benefit of considering interactions.
The method which is used to perform a main effects model is set in \code{screen.main}.\cr
The final model is performed by the main effects resulting from \code{screen.main} and the interactions resulting from \code{screen.inter} as covariates. The method which is used for building the final model is set in \code{fit.final}. As default the same method is used as in \code{screen.main}.
In the following the three components of the framework are explained more in detail:
(1) Fitting a main effects model,
(2) adjusting the data and pre-selecting interaction terms and
(3) building the comprehensive model inclusind promising interactions.

For screening main effects, sprinter allows any approach which can handle with high-dimensional datasets with time-to-event settings. 
The following two established approaches have already been prepared for usage: 
(A) Univariate-Cox regression with adjusted p-values (\code{fit.uniCox}) and (B) CoxBoost (\code{fit.CoxBoost}). Other approaches can also be implemented (see \code{\link{fit.CoxBoost}}). 

For screening the interaction effects, \code{sprinter} offers the random forest method \code{fit.rf} and logic regression \code{fit.logicReg} for pre-selecting interactions.
For each variable a variable importance measurement is calculated that considers the underlying interaction structure and reflects the meaning of a variable for the forest or the logic regression, respectively. 
The variable importance is used to construct the relevant interactions for the model.
Before pre-selecting the interactions, the data are modified so that weaker interaction effects that are originally overlaid by stronger main effects can be detected.
To achieve this, the data are orthogonalized by computing residuals corresponding to the selected main effects and the mandatory covariates.\cr
For better stabilization subsamples are created and the interaction detection approach is performed on each subsampled dataset.
As this step can be computationally expensive it is possible to parallelize this step, by \code{parallel = TRUE}.
To summarize the results of all subsamples, pairwise variable inclusion frequencies of the constructed interactions terms are computed and the \code{n.inter.candidates} most frequent pairs are selected as relevant interaction terms.
Other approaches can also be implemented (see \code{\link{fit.rf}}). 

For building the final model, the user can set the desired method in \code{fit.final}. If no method is required the same method is used as for building the main effects model.
In contrast to building the main effects model, the final model is constructed by the variables selected in the main effects model together with the \code{n.inter.candidates} pre-selected interactions of the screening step. 

}

\value{
An object of class (sprinter) with the following components:
\item{n.inter.candidates}{Number of potential interaction candidates considered in the final model building.}
\item{inter.candidates}{Vector of length \code{n.inter.candidates} with the potential interaction candidates considered in the final model building.}
\item{main.model}{Main effects model. The class depends on the function used in \code{screen.main}.}
\item{final.model}{Final model. The class depends on the function used in \code{fit.final}.}
\item{xnames}{vector of the variable names used in the final model.}
}

\references{
Sariyar, M., Hoffmann, I. Binder, J. (2014). Combining techniques for screening and evaluating interaction terms on high-dimensional time-to-event data. BMC Bioinformatics 15:58.
}
\author{
Written by Isabell Hoffmann \email{isabell.hoffmann@uni-mainz.de}.
}


%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
\code{\link{rfsrc}}, \code{\link{coxph}}, \code{\link{CoxBoost}}

}

\examples{

\dontrun{
##---------------------------
## Survival analysis
##---------------------------

#############################
# Fit a Cox proportional hazards model by CoxBoost by considering 
# interactions after screening interactions by random forest
# system.time:
#   user  system elapsed 
# 370.97    2.32  374.31
# For a faster run set repetitions down!
#############################

# Create survival data with interactions:
simulation <- simul.int(287578,n = 200, p = 500,
                          beta.int = 1.0,
                          beta.main = 0.9, 
                          censparam = 1/20, 
                          lambda = 1/20)
data <- simulation$data

# Showing True Effects:
simulation$info

# Perform the sprinter approach:
set.seed(123)
testcb <- sprinter( x=data[,1:500],  
                    time = data$obs.time,
                    status= data$obs.status,
                    repetitions = 10,
                    mandatory = c("ID1","ID2"),
                    n.inter.candidates = 1000, 
                    screen.main = fit.CoxBoost, 
                    fit.final = fit.CoxBoost, 
                    args.screen.main = list(seed=123,stepno = 10, K = 10, 
                                            criterion ='pscore', nu = 0.05),
                    parallel = FALSE)
summary(testcb)



##########
# Fit a Cox proportional hazards model by considering 
# interactions after screening interactions by random forest
# and selecting relevant effects by univariate Cox regression: 
# system.time:
#   user  system elapsed 
# 374.50    1.53  376.68 
# For a faster run set repetitions down!
##########

# Create survival data with interactions:
data <- simul.int(287578,n = 200, p = 500,
                          beta.int = 1.0,
                          beta.main = 0.9, 
                          censparam = 1/20, 
                          lambda = 1/20)[[1]]


# Perform the sprinter approach:
set.seed(123)
testunicox <- sprinter( x=data[,1:500],  
                    time = data$obs.time,
                    status= data$obs.status,
                    repetitions = 10,
                    mandatory = c("ID1","ID2"),
                    n.inter.candidates = 1000, 
                    screen.main = fit.uniCox, 
                    fit.final = fit.uniCox, 
                    parallel = FALSE)


summary(testunicox)


# true coefficients:
# ID1   ID2   ID5:ID6   ID7:ID8
# 0.9  -0.9      1         -1


##---------------------------
## Continuous outcome
##---------------------------

# selection of main effects by univariate generalized 
# linear models and pre-selections of interactions 
# by random forest:
sprinter.glm.rf.con <- sprinter( x=data[,1:500],  
                    time = data$obs.time,
                    repetitions = 10,
                    mandatory = c("ID1","ID2"),
                    n.inter.candidates = 1000, 
                    screen.main = fit.uniGlm, 
                    fit.final = fit.uniGlm, 
                    parallel = FALSE)

# selection of main effects by univariate generalized 
# linear models and pre-selections of interactions 
# by logic regression:
sprinter.glm.logicR.con <- sprinter( x=data[,1:500],  
                    time = data$obs.time,
                    repetitions = 10,
                    mandatory = c("ID1","ID2"),
                    n.inter.candidates = 1000, 
                    screen.main = fit.uniGlm,
                    screen.inter = fit.logicReg,
                    fit.final = fit.uniGlm, 
                    args.screen.inter = list(type = 2),
                    parallel = FALSE)

# selection of main effects by GAMBoost 
#  and pre-selections of interactions 
# by random forest:
sprinter.gamboost.rf.con <- sprinter( x=data[,1:500],  
                    time = data$obs.time,
                    repetitions = 10,
                    mandatory = c("ID1","ID2"),
                    n.inter.candidates = 1000, 
                    screen.main = fit.GAMBoost, 
                    args.screen.main = list(stepno = 10),
                    fit.final = fit.GAMBoost, 
                    parallel = FALSE)
                    

##---------------------------
## Binary outcome 
##---------------------------
x <- matrix(runif(200*500,min=-1,max=1),200,500)  
colnames(x) <- paste('ID', 1:500, sep = '')
eta <- -0.5 + 2*x[,1] - 2*x[,3] + 2 * x[,3]*x[,4]
y <- rbinom(200,1,binomial()$linkinv(eta))


# selection of main effects by univariate generalized 
# linear models and pre-selections of interactions 
# by random forest:
sprinter.glm.rf.bin <- sprinter( x=x[,1:500],  
                    time = y,
                    repetitions = 10,
                    mandatory = c("ID1","ID2"),
                    n.inter.candidates = 1000, 
                    screen.main = fit.uniGlm, 
                    fit.final = fit.uniGlm, 
                    args.screen.main = list(family = binomial()),
                    parallel = FALSE)
                    
# selection of main effects by univariate generalized 
# linear models and pre-selections of interactions 
# by logic regression:
sprinter.glm.logicR.bin <- sprinter( x=x[,1:500],  
                    time = y,
                    repetitions = 10,
                    mandatory = c("ID1","ID2"),
                    n.inter.candidates = 1000, 
                    screen.main = fit.uniGlm,
                    screen.inter = fit.logicReg,
                    fit.final = fit.uniGlm, 
                    args.screen.inter = list(type = 3),
                    parallel = FALSE)
     

# selection of main effects by GAMBoost and pre-selection of 
# interactions by random forest:

sprinter.GAMBoost.rf.bin <- sprinter( x=x,  
                    time = y,
                    repetitions = 10,
                    mandatory = c("ID1","ID2"),
                    n.inter.candidates = 1000, 
                    screen.main = fit.GAMBoost, 
                    fit.final = fit.GAMBoost, 
                    args.screen.main = list(family = binomial()),
                    parallel = FALSE)
                    
               
}
}