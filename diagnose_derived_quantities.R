# diagnose_derived_quantities.R
# Patrick Applegate, patrick.applegate@psu.edu
# 
# Extracts key quantities from the model runs
# and writes them to .csv files.  

# Mise en place.  
rm(list = ls())
graphics.off()

# Set the directory.  
# setwd("~/Documents/Work/constant_temp/figures_tables")

# Get the signal package (needed for interpolation of the ice
# volume as a function of time curves).  
require(signal)

# Set some variables.  
dTs = c(0, 1, 2, 3, 4.5, 6, 9, 12)
# K; Greenland annual mean temperature perturbations
deltaT_100ka = c("0", "1", "2")
# temp perturbations for which the model was run out
# for 100 ka
deltaT_60ka = c("3", "4p5", "6", "9", "12")
# temp perturbations for which the model was run out
# for 60 ka
nruns = 27    # number of runs that pass the modern ice volume filter
nrows_100ka = 1001
# number of time steps contained in the .ser output 
# files for those runs that were carried out for 100 ka
nrows_60ka = 3001
# number of time steps in the .ser files for those
# runs that were carried out for 60 ka

# Convenient shorthand for matrix indexing.  
n_dTs_100ka = length(deltaT_100ka)
n_dTs_60ka = length(deltaT_60ka)

# Set up matrices to hold the initial ice volumes V_0, the
# final ice volumes V_f, the inferred equilibrium ice volume changes 
# deltaV, the ice volumes at tau V_tau, and the e-folding times tau.  
# These matrices are indexed by temperature change in the rows and
# ice sheet run number in the columns.  
V_0 = matrix(NA, n_dTs_100ka+ n_dTs_60ka, nruns)
V_f = matrix(NA, n_dTs_100ka+ n_dTs_60ka, nruns)
deltaV = matrix(NA, n_dTs_100ka+ n_dTs_60ka, nruns)
V_tau = matrix(NA, n_dTs_100ka+ n_dTs_60ka, nruns)
tau = matrix(NA, n_dTs_100ka+ n_dTs_60ka, nruns)

# Load in curves of ice volume with time for the runs that went
# out to 100 ka, and diagnose the equilibrium ice volume change
# and time scale from these curves.  
for (i in 1: n_dTs_100ka) {
  file = sprintf("data/icevol(t)_dT%s_100ka.csv", deltaT_100ka[i])
  data = read.table(file, sep = ",")
  time = data[, 1]
  for (j in 1: nruns) {
    # Vt: ice volume as a function of time for this run
    Vt = data[, j+ 1]
    # V_0: first element of the ice volume vector
    V_0[i, j] = Vt[1]
    # V_f: last element of the ice volume vector
    V_f[i, j] = Vt[nrows_100ka]
    # deltaV: difference between V_0 and V_f
    deltaV[i, j] = V_0[i, j]- V_f[i, j]
    # V_tau: V_f+ part of deltaV
    V_tau[i, j] = V_f[i, j]+ exp(-1)* deltaV[i, j] 
    # tau: find the point along the ice volume vector that 
    # corresponds to V_tau
    tau[i, j] = interp1(Vt, time, V_tau[i, j], method = "linear", extrap = NA)
  }
}

# As above, but for the runs that go out to 60 ka. 
for (i in 1: n_dTs_60ka) {
  file = sprintf("data/icevol(t)_dT%s_60ka.csv", deltaT_60ka[i])
  data = read.table(file, sep = ",")
  time = data[, 1]
  for (j in 1: nruns) {
    # variables as described above; add n_dTs_100ka to i because 
    # we don't want to overwrite the parts of the output matrices 
    # that contain data from the 100 ka runs
    Vt = data[, j+ 1]
    V_0[i+ n_dTs_100ka, j] = Vt[1]
    V_f[i+ n_dTs_100ka, j] = Vt[nrows_60ka]
    deltaV[i+ n_dTs_100ka, j] = V_0[i+ n_dTs_100ka, j]- V_f[i+ n_dTs_100ka, j]
    V_tau[i+ n_dTs_100ka, j] = V_f[i+ n_dTs_100ka, j]+ exp(-1)* deltaV[i+ n_dTs_100ka, j]
    tau[i+ n_dTs_100ka, j] = interp1(Vt, time, V_tau[i+ n_dTs_100ka, j], method = "linear", extrap = NA)
  }
}

# Write out the extracted variables for each run (arranged as
# temperature change in the rows and runs in the columns).  
dir.create("tables", showWarnings = FALSE)
write.csv(deltaV, "tables/deltaV.csv", row.names = FALSE)
write.csv(V_tau, "tables/V_tau.csv", row.names = FALSE)
write.csv(tau, "tables/tau.csv", row.names = FALSE)