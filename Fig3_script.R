# Fig3_script.R
# Patrick Applegate, patrick.applegate@psu.edu
# 
# Makes plots based on Byron Parizek's flowline model, including
# a comparison between the time scales produced by Byron's model
# and those produced by SICOPOLIS.  

# Mise en place.  
rm(list = ls())
graphics.off()

# Set the directory.  
# setwd("~/Documents/Work/constant_temp/figures_tables")

# Get the signal package (needed for interpolation of the ice
# volume as a function of time curves).  
require(signal)

# Set some values.  
dTs = c(0, 3, 4.5, 6, 12)
color_id = dTs+ 1
columns = c(1, 4, 5, 6, 8)
sia_rows = 1001
sia_rows_490yr = 50
ho_rows = 151
qt_vals = c(0.025, 0.5, 0.975) # quantiles to use for plot #2

# Set colors for plotting.  
# Based on help(colorRamp)
Lab.colors <- colorRampPalette(c("blue", "orange", "red"), space = "Lab")
color = Lab.colors(max(dTs)+ 1)

# Get the results from Byron's runs.  sia, shallow-ice; ho, higher-order.  
sia_data = read.table("data/flowline_sia.csv", header = TRUE, sep = ",")
ho_data = read.table("data/flowline_ho.csv", header = TRUE, sep = ",")
smb_data = read.table("data/flowline_smb_only.csv", header = TRUE, sep = ",")

# Get the time scale information from the SICOPOLIS runs.  
tau_3d = read.csv("tables/tau.csv")

# Extract the quantile values from the SICOPOLIS runs.  
qt_tau = matrix(NA, length(tau_3d[, 1]), length(qt_vals))
for (i in 1: length(tau_3d[, 1])) {
  qt_tau[i, ] = as.numeric(quantile(tau_3d[i, ], qt_vals))
}

# Create the .pdf file and set up the panel structure.  
cairo_pdf(file = "figures/Fig_3.pdf", width = 7.2, height = 3.75, pointsize = 10* 0.8, family = "Helvetica")
par(mfrow = c(1, 2), mar = c(4.5, 4.5, 1, 1))

# Left panel: plot the ice volume curves from Byron's model.  
tau_2d = rep(NA, length(dTs))
for (i in 1: length(dTs)) {
  if (i == 1) {
    plot(sia_data$Time.yr./ 1000, sia_data[, i+ 1], typ = "l", lwd = 0.5, col = color[color_id[i]], bty = "n", ylim = c(0, max(smb_data[, 2: 6])), xlab = expression(paste("Time [", 10^{3}, " yr]")), ylab = expression(paste("Modeled flowline ice volume [", km^{3}, "]")))
  } else {
    lines(sia_data$Time.yr./ 1000, sia_data[, i+ 1], col = color[color_id[i]], lwd = 0.75)
  }
  lines(smb_data$Time.yr./ 1000, smb_data[, i+ 1], col = 'white', lwd = 2, lty = 1)
  lines(smb_data$Time.yr./ 1000, smb_data[, i+ 1], col = color[color_id[i]], lwd = 1, lty = 5)
  lines(ho_data$Time.yr./ 1000, ho_data[, i+ 1], col = color[color_id[i]], lwd = 1)
  points(ho_data$Time.yr.[ho_rows]/ 1000, ho_data[ho_rows, i+ 1], col = color[color_id[i]], pch = 4)
  V_tau_2d = sia_data[sia_rows, i+ 1]+ exp(-1)* (sia_data[1, i+ 1]- sia_data[sia_rows, i+ 1])
  tau_2d[i] = interp1(sia_data[, i+ 1], sia_data[, 1], V_tau_2d)
  points(tau_2d[i]/ 1000, V_tau_2d, pch = 21, col = color[color_id[i]], bg = "white")
}
# account for time not covered by last higher-order 
# run -- extracted from line 50 of flowline_ho.csv
points(490/ 1000, 4982, col = color[color_id[i]], pch = 4)

# Right panel: comparison of time scales from the two models
min_xy = min(min(tau_2d), min(qt_tau))
max_xy = max(max(tau_2d), max(qt_tau))
xy_lims = log10(c(min_xy, max_xy))
plot(log10(tau_2d), log10(qt_tau[columns, 2]), typ = "p", xaxt = "n", yaxt = "n", bty = "n", pch = 16, col = color[color_id], xlim = xy_lims, ylim = xy_lims, xlab = expression(paste("2-D model ", italic('e'), "-folding time [yr], log scale")), ylab = expression(paste("SICOPOLIS ", italic("e"), "-folding time [yr], log scale")))
for (i in 1: length(tau_3d[, 1])) {
  lines(log10(c(tau_2d[i], tau_2d[i])), log10(qt_tau[columns[i], c(1, 3)]), col = color[color_id[i]], lwd = 1)
}
abline(0, 1, lwd = 1, col = "darkgray")
foo = expand.grid(seq(1, 10, 1), 10^seq(1, 5, 1))
foo2 = log10(unique(foo[, 1]* foo[, 2]))
axis(1, at = foo2)
axis(2, at = foo2)
dev.off()