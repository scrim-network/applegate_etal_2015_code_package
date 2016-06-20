# exp_wsse.R
# Patrick Applegate, patrick.applegate@psu.edu
# 
# Function that takes a group of observations in x and y
# and finds the weighted sum of squared errors in the 
# y-direction between the observed and estimated values, 
# assuming the underlying function is a decaying
# exponential like that described by the solution to
# Newton's law of cooling.  Set up for convenient use
# with R's optim command.  
# 
# p, list of parameters for the decaying exponential; 
# p[1], y_0, initial value of the function (where x = 0)
# p[2], y_f, final value of the function (as x becomes large)
# p[3], tau, e-folding distance of the function
# x_obs, list of points in x where observations are available
# y_obs, y-values corresponding to the values in x_obs
# var, variances associated with y_obs; default assigns equal
# weights to all points

exp_wsse <- function(p, x_obs, y_obs, var = rep(1, length(x_obs))) {
  y_0 = p[1]
  y_f = p[2]
  tau = p[3]
  y_est = y_f+ (y_0- y_f)* exp(-x_obs/ tau)
  wsse = sum(var^ -1* (y_est- y_obs)^ 2)
  return(wsse)
}