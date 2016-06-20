# Fig1_ESMFig1.R
# Patrick Applegate, patrick.applegate@psu.edu
# 
# Makes plots of ice volume as a function of time for different
# temperature perturbations.  There are 27 model runs for each temperature
# perturbation, corresponding to those runs from Applegate et al. (2012,
# The Cryosphere) that passed the 10% modern ice volume filter.  
# Some colors from colorbrewer.org.  

# Mise en place.  
rm(list = ls())
graphics.off()

# Set the directory.  
# setwd("~/Documents/Work/constant_temp/figures_tables")

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
xlims = c(100, 80, 60, 30, 12, 6, 3, 1.5)
              # ka; time axis extents in plot #1, listed above

# Set some variables related to the conceptual model (Fig. 1a).  
# Not very meaningful in themselves.  
n_el = 100    # number of elements in the x-direction
eft = 0.15    # e-folding "time" of ice volume decline
initial = 1   # initial "ice volume"
final = 0.2   # final "ice volume"

# Read in matrices of the inferred equilibrium ice 
# volume changes deltaV, the response time scales tau, 
# and the ice volume when tau is reached V_tau.  These 
# matrices are produced by diagnose_derived_quantities.R.  
deltaV = read.csv("tables/deltaV.csv")
tau = read.csv("tables/tau.csv")
V_tau = read.csv("tables/V_tau.csv")

# Set up colors for plotting.  
# Based on help(colorRamp)
Lab.colors <- colorRampPalette(c("blue", "orange", "red"), space = "Lab")
color = Lab.colors(max(dTs)+ 1)

# Convenient shorthand for matrix indexing.  
n_dTs_100ka = length(deltaT_100ka)
n_dTs_60ka = length(deltaT_60ka)

# Plot #1, fig_1a.pdf, which shows the conceptual model of ice sheet
# response to temperature change.  

# Create file, create two-panel structure
cairo_pdf(file = "figures/Fig_1a.pdf", width = 3.25, height = 1.5, pointsize = 10* 0.8, family = "Helvetica")
par(mfrow = c(2, 1))

# Panel 1: temperature anomaly
par(mar = c(1, 4.5, 1, 1), oma = c(0, 0, 0, 2))
plot(c(0, 1.1), c(1, 1), col = "#e31a1c", typ = "l", xaxt = "n", xlim = c(0, 1), ylim = c(-0.1, 1.1), bty = "n", xlab = "", ylab = "Temperature")
lines(c(-0.1, 0), c(0, 0), col = "#e31a1c")
lines(c(0, 0), c(0, 1), col = "#e31a1c")

# Panel 2: ice volume
x = seq(0, 1.1, length.out = n_el)
y = (initial-final)* exp(-x/ eft)+ final
plot(x, y, typ = "l", ylim = c(-0.1, 1.1), col = "#1f78b4", xaxt = "n", bty = "n", xlab = "", ylab = "Ice volume")
lines(c(-0.1, 0), c(initial, initial), col = "#1f78b4")
points(eft, (initial- final)* exp(-1)+ final, pch = 21, bg = "white", col = "#1f78b4")
dev.off()

# Plot #2, fig_1b.pdf, which shows the model results for selected
# deltaT_grl values.  

# Open the file; set up the panel structure.  
cairo_pdf(file = "figures/Fig_1b.pdf", width = 3.25, height = 3, pointsize = 10* 0.8, family = "Helvetica")
par(mar = c(4.5, 4.5, 1, 1), oma = c(0, 0, 0, 2))

# Load in and plot curves of ice volume with time for the runs that went
# out to 100 ka.  
file = "data/icevol(t)_dT1_100ka.csv"
data = read.table(file, sep = ",")
t_100ka = data[, 1]/ 1000
for (j in 1: nruns) {
  if (j == 1) {
    plot(t_100ka, data[, j+ 1], xlim = c(0, 20), ylim = c(0, 8), typ = "l", lwd = 2, col = color[dTs[2]+ 1], bty = "n", xlab = expression(paste("Time [", 10^{3}, " yr]")), ylab = "Modeled ice volume [m sle]")
  } else {
    lines(t_100ka, data[, j+ 1], lwd = 2, col = color[dTs[2]+ 1])
  }
}
points(tau[2, ]/ 1000, V_tau[2, ], pch = 21, col = color[dTs[2]+ 1], bg = "white")

# As above, but for the runs that go out to 60 ka.  
for (i in c(1, 3)) {
  file = sprintf("data/icevol(t)_dT%s_60ka.csv", deltaT_60ka[i])
  data = read.table(file, sep = ",")
  t_60ka = data[, 1]/ 1000
  for (j in 1: nruns) {
      lines(t_60ka, data[, j+ 1], lwd = 2, col = color[dTs[i+ n_dTs_100ka]+ 1])
  }
  points(tau[i+ n_dTs_100ka, ]/ 1000, V_tau[i+ n_dTs_100ka, ], pch = 21, col = color[dTs[i+ n_dTs_100ka]+ 1], bg = "white")
}

# Write some labels on the plot to indicate the different imposed temperature anomalies.  
mtext("1 K", line = -0.5, side = 4, outer = TRUE, adj = 0.65, col = color[2])
mtext("3 K", line = -0.5, side = 4, outer = TRUE, adj = 0.35, col = color[4])
mtext("6 K", line = -0.5, side = 4, outer = TRUE, adj = 0.22, col = color[7])
dev.off()

# Plot #3, ESM_Fig_1.pdf, which shows all the model runs.  

# Open the file; create the panel structure.  
cairo_pdf(file = "figures/ESM_Fig_1.pdf", width = 7.2, height = 5, pointsize = 10, family = "Helvetica")
par(mfrow = c(2, 4), mar = c(2, 2, 1, 1), oma = c(4, 4, 1, 1))

# Load in and plot curves of ice volume with time for the runs that went
# out to 100 ka.  
for (i in 1: n_dTs_100ka) {
  file = sprintf("data/icevol(t)_dT%s_100ka.csv", deltaT_100ka[i])
  data = read.table(file, sep = ",")
  t_100ka = data[, 1]/ 1000
  for (j in 1: nruns) {
    if (j == 1) {
      plot(t_100ka, data[, j+ 1], xlim = c(0, xlims[i]), ylim = c(0, 8), typ = "l", lwd = 2, col = color[dTs[i]+ 1], bty = "n", xlab = "", ylab = "")
    } else {
      lines(t_100ka, data[, j+ 1], lwd = 2, col = color[i])
    }
  }
  points(tau[i, ]/ 1000, V_tau[i, ], pch = 21, col = color[dTs[i]+ 1], bg = "white")
  dT_text = as.character(sprintf(" = %s K", dTs[i]))
  text(0.9* xlims[i], y = 7.5, sprintf("%s K", dTs[i]), pos = 2, col = color[dTs[i]+ 1])
}

# As above, but for the runs that go out to 60 ka.  
for (i in 1: n_dTs_60ka) {
  file = sprintf("data/icevol(t)_dT%s_60ka.csv", deltaT_60ka[i])
  data = read.table(file, sep = ",")
  t_60ka = data[, 1]/ 1000
  for (j in 1: nruns) {
    if (j == 1) {
      plot(t_60ka, data[, j+ 1], xlim = c(0, xlims[i+ n_dTs_100ka]), ylim = c(0, 8), typ = "l", lwd = 2, bty = "n", col = color[dTs[i+ n_dTs_100ka]+ 1], xlab = "", ylab = "")
    } else {
      lines(t_60ka, data[, j+ 1], lwd = 2, col = color[dTs[i+ n_dTs_100ka]+ 1])
    }
  }
  points(tau[i+ n_dTs_100ka, ]/ 1000, V_tau[i+ n_dTs_100ka, ], pch = 21, col = color[dTs[i+ n_dTs_100ka]+ 1], bg = "white")
  text(0.9* xlims[i+ n_dTs_100ka], y = 7.5, pos = 2, sprintf("%s K", dTs[i+ n_dTs_100ka]), col = color[dTs[i+ n_dTs_100ka]+ 1])
}
# Write some labels on the plot margins to indicate what is being shown.  
mtext(expression(paste("Time [", 10^{3}, " yr]")), side = 1, line = 1.5, outer = TRUE)
mtext("Modeled ice volume [m sle]", side = 2, line = 1.5, outer = TRUE)
dev.off()