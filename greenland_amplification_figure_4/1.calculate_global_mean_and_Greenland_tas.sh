#!/bin/bash

OUTDIR="tas_timeseries"
mkdir $OUTDIR || exit

INFILE_DIR="tas_raw"

INFILE_LIST="`ls $INFILE_DIR/*.nc`"
for INFILE in $INFILE_LIST ; do
   MODEL="`basename $INFILE | cut -d _ -f 3`"
   FORCING="`basename $INFILE | cut -d _ -f 4`"
   RUN="`basename $INFILE | cut -d _ -f 5`"
   echo ; basename $INFILE
   #
   GLOBALMEAN="$OUTDIR/tas.ann.$FORCING.$MODEL.$RUN.global_mean.1970-2099.nc"
   cdo -a fldmean -yearmean -seldate,1970-01-01,2099-12-31 -selname,tas $INFILE $GLOBALMEAN
   #
   GREENLAND="$OUTDIR/tas.ann.$FORCING.$MODEL.$RUN.Greenland.1970-2099.nc"
   cdo -a fldmean -add greenland_mask.nc -remapbil,greenland_mask.nc -yearmean -seldate,1970-01-01,2099-12-31 -selname,tas $INFILE $GREENLAND
done
echo

INFILE_LIST="`ls $INFILE_DIR/*2299*.nc $INFILE_DIR/*2300*.nc`"
for INFILE in $INFILE_LIST ; do
   MODEL="`basename $INFILE | cut -d _ -f 3`"
   FORCING="`basename $INFILE | cut -d _ -f 4`"
   RUN="`basename $INFILE | cut -d _ -f 5`"
   echo ; basename $INFILE
   #
   GLOBALMEAN="$OUTDIR/tas.ann.$FORCING.$MODEL.$RUN.global_mean.1970-2299.nc"
   cdo -a fldmean -yearmean -seldate,1970-01-01,2299-12-31 -selname,tas $INFILE $GLOBALMEAN
   #
   GREENLAND="$OUTDIR/tas.ann.$FORCING.$MODEL.$RUN.Greenland.1970-2299.nc"
   cdo -a fldmean -add greenland_mask.nc -remapbil,greenland_mask.nc -yearmean -seldate,1970-01-01,2299-12-31 -selname,tas $INFILE $GREENLAND
done
echo

