#!/bin/env Rscript
# NOTE: Tested with R vesion 2.15.3

library(ncdf)

###################################################################################################
### DEFINE FUNCTIONS
###################################################################################################

# Clear existing functions and variables.
rm(list=ls())

# hArrow() : Draw a horizontal, two-headed arrow with range bars at each end.
hArrow <- function( xbeg, xend, ypos, xscale, yscale, color ){
    lthick <- 3
    alen <- 0.06*xscl
    hlen <- 0.04*yscl
    arrows( x0=xbeg+0.02*xscl, y0=ypos, x1=xend-0.02*xscl, y1=ypos, col=color, lwd=lthick, length=alen, code=3 )
    segments( x0=xbeg, y0=ypos-hlen, x1=xbeg, y1=ypos+hlen, col=color, lwd=lthick )
    segments( x0=xend, y0=ypos-hlen, x1=xend, y1=ypos+hlen, col=color, lwd=lthick )
}

# vArrow() : Draw a vertical, two-headed arrow with range bars at each end.
vArrow <- function( ybeg, yend, xpos, xscale, yscale, color ){
    lthick <- 3
    alen <- 0.06*xscl
    hlen <- 0.04*xscl
    arrows( x0=xpos, y0=ybeg+0.02*yscl, x1=xpos, y1=yend-0.02*yscl, col=color, lwd=lthick, length=alen, code=3 )
    segments( x0=xpos-hlen, y0=ybeg, x1=xpos+hlen, y1=ybeg, col=color, lwd=lthick )
    segments( x0=xpos-hlen, y0=yend, x1=xpos+hlen, y1=yend, col=color, lwd=lthick )
}

###################################################################################################
### MAIN PROGRAM
###################################################################################################

greenland_file <- system("ls tas_timeseries/tas.ann.historical+rcp85.*.*.Greenland.1970-2*.nc",TRUE)
idx_long <- grep("2299",greenland_file)
idx_short <- grep("2099",greenland_file)
n_all_runs <- length(greenland_file)
n_long_runs <- length(idx_long)
long_run <- array(FALSE,length(greenland_file))
long_run[idx_long] <- TRUE
year <- 1970:2299
idx_clim <- 1:30  # years 1970-1999
idx21 <- 1:130 
end21 <- 101:130  # years 2070-2099
idx23 <- 1:330
end23 <- 301:330  # years 2270-2299

greenland_sat <- array(NA,c(length(year),length(greenland_file)))
global_sat <- array(NA,c(length(year),length(greenland_file)))
amp21 <- array(NA,length(greenland_file))
amp23 <- array(NA,length(greenland_file))
greenland_dT21 <- array(NA,length(greenland_file))
greenland_dT23 <- array(NA,length(greenland_file))
global_dT21 <- array(NA,length(greenland_file))
global_dT23 <- array(NA,length(greenland_file))
cat("\n")
cat("global  Greenland    Greenland                              end \n")
cat("dT (K)   dT (K)    amplification      model       run spec  year\n")
cat("======  =========  =============  ==============  ========  ====\n")


for (i in 1:length(greenland_file)) {
    # grab info on model and run
    model <- system( paste("basename",greenland_file[i],"| cut -d . -f 4 \n"), TRUE )
    runinfo <- system( paste("basename",greenland_file[i],"| cut -d . -f 5 \n"), TRUE )

    # get Greenland mean SAT timeseries
    ncfile <- open.ncdf(greenland_file[i])
    greenland_ts <- get.var.ncdf(ncfile,"tas")
    BLACK_HOLE = close.ncdf(ncfile)
    greenland_sat[1:length(greenland_ts),i] <- greenland_ts - mean(greenland_ts[idx_clim])

    # get global mean SAT timeseries
    global_file <- system(paste("echo ",greenland_file[i]," | sed 's/Greenland/global_mean/g'",sep=""),TRUE)
    ncfile <- open.ncdf(global_file)
    global_ts <- get.var.ncdf(ncfile,"tas")
    BLACK_HOLE = close.ncdf(ncfile)
    global_sat[1:length(global_ts),i] <- global_ts - mean(global_ts[idx_clim])

    greenland_dT21[i] <- mean(greenland_sat[end21,i])
    global_dT21[i] <- mean(global_sat[end21,i])
    amp21[i] <- greenland_dT21[i] / global_dT21[i]
    cat(sprintf("%6.3f ",global_dT21[i]),sprintf("%9.3f ",greenland_dT21[i]),sprintf("%13.3f ",amp21[i]),sprintf("%-14s ",model),sprintf("%-7s",runinfo),"  2099\n")

    if(long_run[i]) {
        greenland_dT23[i] <- mean(greenland_sat[end23,i])
        global_dT23[i] <- mean(global_sat[end23,i])
        amp23[i] <- greenland_dT23[i] / global_dT23[i]
        cat(sprintf("%6.3f ",global_dT23[i]),sprintf("%9.3f ",greenland_dT23[i]),sprintf("%13.3f ",amp23[i]),sprintf("%-14s ",model),sprintf("%-7s",runinfo),"  2299\n")
    }
}

cat("\n")

cat("Global mean temperature change (1970-1999 to 2070-2099, all ", n_all_runs, " runs) = ",sprintf("%4.3f",mean(global_dT21))," [",sprintf("%4.3f",min(global_dT21)),",",sprintf("%4.3f",max(global_dT21)),"] K\n",sep="")
cat("Greenland mean temperature change (1970-1999 to 2070-2099, all ", n_all_runs, " runs) = ",sprintf("%4.3f",mean(greenland_dT21))," [",sprintf("%4.3f",min(greenland_dT21)),",",sprintf("%4.3f",max(greenland_dT21)),"] K\n",sep="")
cat("Greenland amplification (1970-1999 to 2070-2099, all ", n_all_runs, " runs) = ",sprintf("%4.3f",mean(amp21))," [",sprintf("%4.3f",min(amp21)),",",sprintf("%4.3f",max(amp21)),"]\n\n",sep="")

cat("Global mean temperature change (1970-1999 to 2070-2099, ", n_long_runs, " long runs) = ",sprintf("%4.3f",mean(global_dT21[idx_long]))," [",sprintf("%4.3f",min(global_dT21[idx_long])),",",sprintf("%4.3f",max(global_dT21[idx_long])),"] K\n",sep="")
cat("Greenland mean temperature change (1970-1999 to 2070-2099, ", n_long_runs, " long runs) = ",sprintf("%4.3f",mean(greenland_dT21[idx_long]))," [",sprintf("%4.3f",min(greenland_dT21[idx_long])),",",sprintf("%4.3f",max(greenland_dT21[idx_long])),"] K\n",sep="")
cat("Greenland amplification (1970-1999 to 2070-2099, ", n_long_runs, " long runs) = ",sprintf("%4.3f",mean(amp21[idx_long]))," [",sprintf("%4.3f",min(amp21[idx_long])),",",sprintf("%4.3f",max(amp21[idx_long])),"]\n\n",sep="")

cat("Global mean temperature change (1970-1999 to 2270-2299, all ", n_all_runs, " runs) = ",sprintf("%4.3f",mean(global_dT23[idx_long]))," [",sprintf("%4.3f",min(global_dT23[idx_long])),",",sprintf("%4.3f",max(global_dT23[idx_long])),"] K\n",sep="")
cat("Greenland mean temperature change (1970-1999 to 2270-2299, all ", n_all_runs, " runs) = ",sprintf("%4.3f",mean(greenland_dT23[idx_long]))," [",sprintf("%4.3f",min(greenland_dT23[idx_long])),",",sprintf("%4.3f",max(greenland_dT23[idx_long])),"] K\n",sep="")
cat("Greenland amplification (1970-1999 to 2270-2299, all ", n_all_runs, " runs) = ",sprintf("%4.3f",mean(amp23[idx_long]))," [",sprintf("%4.3f",min(amp23[idx_long])),",",sprintf("%4.3f",max(amp23[idx_long])),"]\n\n",sep="")

pdf("figure_4.pdf")
matplot( year, greenland_sat, type="l", lty=c(1,1), lwd=1, col="#C1FFC1", xlim=c(1970,2300), ylim=c(-2,22), main='all RCP8.5 runs', xlab='year', ylab='surface air temperature anomaly (K)' )
matlines( year, global_sat, type="l", lty=c(1,1), lwd=1, col="#ADD8E6" )
lines( year, rowMeans(greenland_sat), col="#228B22", lwd=3 )
lines( year, rowMeans(greenland_sat[,idx_long]), col="#228B22", lwd=3 )
lines( year, rowMeans(global_sat), col="#00008B", lwd=3 )
lines( year, rowMeans(global_sat[,idx_long]), col="#00008B", lwd=3 )
amp_string21 = paste("Greenland amplification (100 yrs) = ",sprintf("%3.2f",mean(amp21))," [",sprintf("%3.2f",min(amp21)),", ",sprintf("%3.2f",max(amp21)),"]", sep="")
text( 2060, -0.25, amp_string21, pos=4, col="#CD2626" )
amp_string23 = paste("Greenland amplification (300 yrs) = ",sprintf("%3.2f",mean(amp23[idx_long]))," [",sprintf("%3.2f",min(amp23[idx_long])),", ",sprintf("%3.2f",max(amp23[idx_long])),"]", sep="")
text( 2060, -1.5, amp_string23, pos=4, col="orange" )
segments( x0=1970, y0=21.25, x1=1990, y1=21.25, col="#C1FFC1", lwd=5 )
text( 1990, 21.25, "Greenland (individual runs)", pos=4 )
segments( x0=1970, y0=20.00, x1=1990, y1=20.00, col="#228B22", lwd=5 )
text( 1990, 20.00, "Greenland (ensemble mean)", pos=4 )
segments( x0=1970, y0=18.75, x1=1990, y1=18.75, col="#ADD8E6", lwd=5 )
text( 1990, 18.75, "Global (individual runs)", pos=4 )
segments( x0=1970, y0=17.50, x1=1990, y1=17.50, col="#00008B", lwd=5 )
text( 1990, 17.50, "Global (ensemble mean)", pos=4 )
