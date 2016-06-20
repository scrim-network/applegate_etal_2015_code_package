# Fig2_script.R
# Patrick Applegate, patrick.applegate@psu.edu
# 
# Makes a figure that shows
# 1) top panel, time scale of response as a function
# of temperature perturbation
# 2) bottom panel, ice volume change as a function of temperature
# perturbation
# Some colors from colorbrewer.org.  

# Mise en place.  
rm(list = ls())
graphics.off()

# Set the directory.  
# setwd("~/Documents/Work/constant_temp/figures_tables")

# Go get the exp_wsse function for fitting a decaying
# exponential to the model results.  
source("exp_wsse.R")

# Get the signal package (needed for interpolation).  
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
qt_vals = c(0.025, 0.5, 0.975)
              # quantiles to use for plot #2
est_vol = 7.1914
              # approximate modern volume of the ice sheet, based on
              # Ralf Greve's gridding of Bamber et al. (2001)
nruns = 27    # number of runs that pass the modern ice volume filter
dT_ratio = 1.517
              # mean ratio of Greenland temperature change to global
              # mean, in a selection of RCP 8.5 runs from the
              # CMIP5 archive
dT_range_2100 = c(3.292, 8.170)
              # extremes of Greenland temperature change by 2100
              # in RCP 8.5 runs mentioned above
dT_range_2300 = c(4.899, 21.405)
              # extremes of Greenland temperature change by 3100
              # in RCP 8.5 runs mentioned above

# Create colors for plotting.  
# Based on help(colorRamp)
Lab.colors <- colorRampPalette(c("blue", "orange", "red"), space = "Lab")
color = Lab.colors(max(dTs)+ 1)
line_color = Lab.colors(100)

# Read in matrices of the inferred equilibrium ice volume 
# changes deltaV, the response time scales tau, and the 
# ice volume when tau is reached V_tau.  These matrices 
# are produced by diagnose_derived_quantities.R.  
deltaV = read.csv("tables/deltaV.csv")
tau = read.csv("tables/tau.csv")
V_tau = read.csv("tables/V_tau.csv")

# Plot: extract the median and 95% probable interval from the stored
# deltaV and tau matrices and plot them as a function of the
# temperature perturbation.  

# Set up matrices to store the quantile values.  
qt_deltaV = matrix(NA, length(deltaT_100ka)+ length(deltaT_60ka), length(qt_vals))
qt_tau = matrix(NA, length(deltaT_100ka)+ length(deltaT_60ka), length(qt_vals))
deltaV_var = rep(NA, length(qt_vals))
tau_var = rep(NA, length(qt_vals))

# Extract the quantile values.  
for (i in 1: (length(deltaT_100ka)+ length(deltaT_60ka))) {
  qt_deltaV[i, ] = as.matrix(quantile(deltaV[i, ], qt_vals))
  qt_tau[i, ] = as.matrix(quantile(tau[i, ], qt_vals))
  deltaV_var[i] = unlist(quantile(deltaV[i, ], 0.84)- quantile(deltaV[i, ], 0.16))
  tau_var[i] = unlist(quantile(tau[i, ], 0.84)- quantile(tau[i, ], 0.16))
}

# Fit a decaying exponential to the median tau and deltaV
# values to account for temperatures where we don't have
# model runs.  
dTs_vec = seq(min(dTs), max(dTs), length.out = 100)
tau_fn = optim(c(qt_tau[1, 2], 0, 1), exp_wsse, x_obs = dTs, y_obs = qt_tau[, 2], var = tau_var, method = "L-BFGS-B", lower = c(0, 0, 0))
deltaV_fn = optim(c(qt_deltaV[1, 2], qt_deltaV[8, 2], 1), exp_wsse, x_obs = dTs, y_obs = qt_deltaV[, 2], var = deltaV_var, method = "L-BFGS-B", lower = c(0, 0, 0))
tau_vec = tau_fn$par[2]+ (tau_fn$par[1]- tau_fn$par[2])* exp(-dTs_vec/ tau_fn$par[3])
deltaV_vec = deltaV_fn$par[2]+ (deltaV_fn$par[1]- deltaV_fn$par[2])* exp(-dTs_vec/ deltaV_fn$par[3])

# By extrapolation, find the deltaT_grl value where
# deltaV becomes 0.  This is the deltaT_grl value for
# which the ice sheet would be in balance (more or less).  
deltaT_inbal = -deltaV_fn$par[3]* log(-deltaV_fn$par[2]/ (deltaV_fn$par[1]- deltaV_fn$par[2]))

# If interpolating instead of fitting, uncomment the
# following two lines.  
# deltaV_vec = interp1(dTs, qt_deltaV[, 2], dTs_vec, "pchip")
# tau_vec = interp1(dTs, qt_tau[, 2], dTs_vec, "pchip")

# Make the plot.  
cairo_pdf(file = "figures/Fig_2.pdf", width = 3.25, height = 6, pointsize = 10* 0.8, family = "Helvetica")
par(mfrow = c(2, 1))

# top panel: time scales
par(mar = c(1, 4.5, 4.5, 2))
plot(dTs_vec, tau_vec, typ = "l", col = "black", lwd = 0, xaxt = "n", yaxt = "n", bty = "n", ylim = round(log10(c(min(tau), max(tau))), 1), xlab = "", ylab = expression(paste("Time scale ", tau, " [yr], log scale")))
# best-fit line
segments(dTs_vec[1: 99], log10(tau_vec[1: 99]), dTs_vec[2: 100], log10(tau_vec[2: 100]), col = line_color, lwd = 1.5)
# error bars (95% CI)
segments(x0 = dTs, y0 = log10(qt_tau[, 1]), y1 = log10(qt_tau[, 3]), lwd = 1, col = color[dTs+ 1])
# median values
points(dTs, log10(qt_tau[, 2]), pch = 16, col = color[dTs+ 1])
# make the axes look nice
foo = expand.grid(seq(1, 10, 1), 10^seq(1, 5, 1))
foo2 = unique(foo[, 1]* foo[, 2])
axis(3, at = seq(0, 8, 1)* dT_ratio, labels = as.character(seq(0, 8, 1)))
mtext(expression(paste("Global mean temperature change ", Delta, T[global], " [K]")), side = 3, line = 2)
axis(2, at = log10(foo2))
# add a line for the time scale estimate from Wigley et al.  
abline(h = log10(300), lwd = 1.0, col = "darkgray")
text(0, log10(350), adj = c(0, 0), "Assessed minimum response time (300 yr)", col = "darkgray")

# bottom panel: equilibrium ice volume changes
par(mar = c(4.5, 4.5, 1, 2))
plot(dTs_vec, deltaV_vec, typ = "l", col = "black", lwd = 0, bty = "n", ylim = c(min(deltaV), max(deltaV)), xlab = expression(paste("Greenland temperature change ", Delta, T[grl], " [K]")), ylab = expression(paste("Equilibrium sea level contribution ", Delta, "V [m sle]")))
# best-fit line
segments(dTs_vec[1: 99], deltaV_vec[1: 99], dTs_vec[2: 100], deltaV_vec[2: 100], col = line_color, lwd = 1.5)
# error bars (95% CI)
segments(x0 = dTs, y0 = qt_deltaV[, 1], y1 = qt_deltaV[, 3], lwd = 1, col = color[dTs+ 1])
# median values
points(dTs, qt_deltaV[, 2], typ = "p", pch = 16, col = color[dTs+ 1])
# add a line indicating the modern ice volume from Bamber et al.  
abline(h = est_vol, lwd = 1.0, col = "darkgray")
text(0, 7.3, adj = c(0, 0), "Estimated modern ice volume (7.3 m sle)", col = "darkgray")
text(11.5, 3.4, adj = c(1, 0), expression(paste("GCM-estimated ", Delta, T[grl], " ranges")), col = "#fb9a99")
# add GCM temp ranges
text(mean(dT_range_2100), 3, "2100 (3.3-8.2 K)", col = "#fb9a99")
text(mean(dT_range_2300)- 3, 2.25, "2300 (4.9-21.4 K)", col = "#fb9a99")
lines(dT_range_2100, rep(2.75, 2), lwd = 2, col = "#fb9a99")
lines(dT_range_2300, rep(2, 2), lwd = 2, col = "#fb9a99")

# stop editing the .pdf file
dev.off()