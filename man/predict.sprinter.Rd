\name{predict.sprinter}
\alias{predict.sprinter}
\title{Predict method for objects of class \code{sprinter}}
\description{
Evaluates the linear predictor from a Cox proportional Hazards model fitted by \code{\link{sprinter}}.  
}
\usage{
\method{predict}{sprinter}(object, newdata=NULL,\ldots)
}
\arguments{
\item{object}{Cox proportional Hazards model from a \code{\link{sprinter}} call.}
\item{newdata}{\code{n.new * p} matrix with new covariate values. If just prediction for the training data is wanted, it can be omitted.}
\item{\dots}{additional arguments.}
}

\value{
The linear predictor, a vector of length \code{n.new}, is returned.  
}

\author{
Isabell Hoffmann \email{isabell.hoffmann@uni-mainz.de}
}

\examples{
simulation <- simul.int(287578,n = 200, p = 500,
                          beta.int = 1.0,
                          beta.main = 0.9, 
                          censparam = 1/20, 
                          lambda = 1/20)
data <- simulation$data    
simulation$info

set.seed(123)

\dontrun{
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
                    parallel = FALSE, trace=TRUE)
summary(testcb)


# true coefficients:
# Clin.cov1   Clin.cov2   ID5:ID6   ID7:ID8
# 0.9         -0.9        1         -1

# Simulate New Data:
newSimulation <- simul.int(12345,n = 200, p = 500,
                          beta.int = 1.0,
                          beta.main = 0.9, 
                          censparam = 1/20, 
                          lambda = 1/20)
newdata <- newSimulation$data    
newSimulation$info

predict(testcb, newdata = newdata[,1:500]) 
}
}
