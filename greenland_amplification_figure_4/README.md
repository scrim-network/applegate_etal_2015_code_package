# Preamble

The files in this directory will generate Figure 4 from Applegate et al. (2015, _Climate Dynamics_).  The files in this directory were written by Robert E. Nicholas.  

# Requirements

- a Unix-like environment with the usual command-line tools (tested on Red Hat Enterprise Linux 6)
- Bash (tested with version 4.1.2)
- R (tested with version 2.15.3) with the 'ncdf' library
- the Climate Data Operators (CDO) utility (tested with version 1.7.1)
- CMIP5 climate model output as described below
- the files in this directory:
    * `README.md` (this file)
    * `1.calculate_global_mean_and_Greenland_tas.sh`
    * `2.create_multiple_timeseries_and_amplification_plots.R`
    * `greenland_mask.nc`

To create Figure 4, you'll need a directory 'tas_raw' containing monthly historical and RCP8.5 surface air temperature fields ('tas') spliced into single files for each run.  The necessary historical and RCP8.5 data files may be obtained from the CMIP5 repository currently hosted by the Earth System Grid and then spliced as necessary.  

The spliced files used for this analysis are:

    ./tas_raw/tas_Amon_ACCESS1-0_historical+rcp85_r1i1p1_185001-210012.nc
    ./tas_raw/tas_Amon_ACCESS1-3_historical+rcp85_r1i1p1_185001-210012.nc
    ./tas_raw/tas_Amon_bcc-csm1-1_historical+rcp85_r1i1p1_185001-230012.nc
    ./tas_raw/tas_Amon_bcc-csm1-1-m_historical+rcp85_r1i1p1_185001-209912.nc
    ./tas_raw/tas_Amon_BNU-ESM_historical+rcp85_r1i1p1_185001-210012.nc
    ./tas_raw/tas_Amon_CanESM2_historical+rcp85_r1i1p1_185001-210012.nc
    ./tas_raw/tas_Amon_CanESM2_historical+rcp85_r2i1p1_185001-210012.nc
    ./tas_raw/tas_Amon_CanESM2_historical+rcp85_r3i1p1_185001-210012.nc
    ./tas_raw/tas_Amon_CanESM2_historical+rcp85_r4i1p1_185001-210012.nc
    ./tas_raw/tas_Amon_CanESM2_historical+rcp85_r5i1p1_185001-210012.nc
    ./tas_raw/tas_Amon_CCSM4_historical+rcp85_r1i1p1_185001-230012.nc
    ./tas_raw/tas_Amon_CCSM4_historical+rcp85_r2i1p1_185001-210012.nc
    ./tas_raw/tas_Amon_CCSM4_historical+rcp85_r3i1p1_185001-210012.nc
    ./tas_raw/tas_Amon_CCSM4_historical+rcp85_r4i1p1_185001-210012.nc
    ./tas_raw/tas_Amon_CCSM4_historical+rcp85_r5i1p1_185001-210012.nc
    ./tas_raw/tas_Amon_CCSM4_historical+rcp85_r6i1p1_185001-210012.nc
    ./tas_raw/tas_Amon_CESM1-BGC_historical+rcp85_r1i1p1_185001-210012.nc
    ./tas_raw/tas_Amon_CESM1-CAM5_historical+rcp85_r1i1p1_185001-210012.nc
    ./tas_raw/tas_Amon_CESM1-CAM5_historical+rcp85_r2i1p1_185001-210012.nc
    ./tas_raw/tas_Amon_CESM1-CAM5_historical+rcp85_r3i1p1_185001-210012.nc
    ./tas_raw/tas_Amon_CESM1-WACCM_historical+rcp85_r2i1p1_195501-209912.nc
    ./tas_raw/tas_Amon_CMCC-CESM_historical+rcp85_r1i1p1_185001-210012.nc
    ./tas_raw/tas_Amon_CMCC-CM_historical+rcp85_r1i1p1_185001-210012.nc
    ./tas_raw/tas_Amon_CMCC-CMS_historical+rcp85_r1i1p1_185001-210012.nc
    ./tas_raw/tas_Amon_CNRM-CM5_historical+rcp85_r10i1p1_185001-210012.nc
    ./tas_raw/tas_Amon_CNRM-CM5_historical+rcp85_r1i1p1_185001-230012.nc
    ./tas_raw/tas_Amon_CNRM-CM5_historical+rcp85_r2i1p1_185001-210012.nc
    ./tas_raw/tas_Amon_CNRM-CM5_historical+rcp85_r4i1p1_185001-210012.nc
    ./tas_raw/tas_Amon_CNRM-CM5_historical+rcp85_r6i1p1_185001-210012.nc
    ./tas_raw/tas_Amon_CSIRO-Mk3-6-0_historical+rcp85_r10i1p1_185001-210012.nc
    ./tas_raw/tas_Amon_CSIRO-Mk3-6-0_historical+rcp85_r1i1p1_185001-230012.nc
    ./tas_raw/tas_Amon_CSIRO-Mk3-6-0_historical+rcp85_r2i1p1_185001-230012.nc
    ./tas_raw/tas_Amon_CSIRO-Mk3-6-0_historical+rcp85_r3i1p1_185001-230012.nc
    ./tas_raw/tas_Amon_CSIRO-Mk3-6-0_historical+rcp85_r4i1p1_185001-210012.nc
    ./tas_raw/tas_Amon_CSIRO-Mk3-6-0_historical+rcp85_r5i1p1_185001-210012.nc
    ./tas_raw/tas_Amon_CSIRO-Mk3-6-0_historical+rcp85_r6i1p1_185001-210012.nc
    ./tas_raw/tas_Amon_CSIRO-Mk3-6-0_historical+rcp85_r7i1p1_185001-210012.nc
    ./tas_raw/tas_Amon_CSIRO-Mk3-6-0_historical+rcp85_r8i1p1_185001-210012.nc
    ./tas_raw/tas_Amon_CSIRO-Mk3-6-0_historical+rcp85_r9i1p1_185001-210012.nc
    ./tas_raw/tas_Amon_EC-EARTH_historical+rcp85_r12i1p1_185001-210012.nc
    ./tas_raw/tas_Amon_EC-EARTH_historical+rcp85_r13i1p1_185001-210012.nc
    ./tas_raw/tas_Amon_EC-EARTH_historical+rcp85_r1i1p1_185001-210012.nc
    ./tas_raw/tas_Amon_EC-EARTH_historical+rcp85_r2i1p1_185001-210012.nc
    ./tas_raw/tas_Amon_EC-EARTH_historical+rcp85_r6i1p1_190001-210012.nc
    ./tas_raw/tas_Amon_EC-EARTH_historical+rcp85_r8i1p1_185001-210012.nc
    ./tas_raw/tas_Amon_EC-EARTH_historical+rcp85_r9i1p1_185001-210012.nc
    ./tas_raw/tas_Amon_FGOALS-g2_historical+rcp85_r1i1p1_185001-210112.nc
    ./tas_raw/tas_Amon_FIO-ESM_historical+rcp85_r1i1p1_185001-210012.nc
    ./tas_raw/tas_Amon_FIO-ESM_historical+rcp85_r2i1p1_185001-210012.nc
    ./tas_raw/tas_Amon_FIO-ESM_historical+rcp85_r3i1p1_185001-210012.nc
    ./tas_raw/tas_Amon_GFDL-CM3_historical+rcp85_r1i1p1_186001-210012.nc
    ./tas_raw/tas_Amon_GFDL-ESM2G_historical+rcp85_r1i1p1_186101-210012.nc
    ./tas_raw/tas_Amon_GFDL-ESM2M_historical+rcp85_r1i1p1_186101-220012.nc
    ./tas_raw/tas_Amon_GISS-E2-H-CC_historical+rcp85_r1i1p1_185001-210012.nc
    ./tas_raw/tas_Amon_GISS-E2-H_historical+rcp85_r1i1p1_185001-230012.nc
    ./tas_raw/tas_Amon_GISS-E2-H_historical+rcp85_r1i1p2_185001-230012.nc
    ./tas_raw/tas_Amon_GISS-E2-H_historical+rcp85_r1i1p3_185001-230012.nc
    ./tas_raw/tas_Amon_GISS-E2-R-CC_historical+rcp85_r1i1p1_185001-210012.nc
    ./tas_raw/tas_Amon_GISS-E2-R_historical+rcp85_r1i1p1_185001-230012.nc
    ./tas_raw/tas_Amon_GISS-E2-R_historical+rcp85_r1i1p2_185001-230012.nc
    ./tas_raw/tas_Amon_GISS-E2-R_historical+rcp85_r1i1p3_185001-230012.nc
    ./tas_raw/tas_Amon_HadGEM2-AO_historical+rcp85_r1i1p1_186001-210012.nc
    ./tas_raw/tas_Amon_HadGEM2-CC_historical+rcp85_r1i1p1_185912-210012.nc
    ./tas_raw/tas_Amon_HadGEM2-CC_historical+rcp85_r2i1p1_195912-209912.nc
    ./tas_raw/tas_Amon_HadGEM2-CC_historical+rcp85_r3i1p1_195912-209912.nc
    ./tas_raw/tas_Amon_HadGEM2-ES_historical+rcp85_r2i1p1_185912-210012.nc
    ./tas_raw/tas_Amon_HadGEM2-ES_historical+rcp85_r3i1p1_185912-210012.nc
    ./tas_raw/tas_Amon_HadGEM2-ES_historical+rcp85_r4i1p1_185912-210012.nc
    ./tas_raw/tas_Amon_inmcm4_historical+rcp85_r1i1p1_185001-210012.nc
    ./tas_raw/tas_Amon_IPSL-CM5A-LR_historical+rcp85_r1i1p1_185001-230012.nc
    ./tas_raw/tas_Amon_IPSL-CM5A-LR_historical+rcp85_r2i1p1_185001-210012.nc
    ./tas_raw/tas_Amon_IPSL-CM5A-LR_historical+rcp85_r3i1p1_185001-210012.nc
    ./tas_raw/tas_Amon_IPSL-CM5A-LR_historical+rcp85_r4i1p1_185001-210012.nc
    ./tas_raw/tas_Amon_IPSL-CM5A-MR_historical+rcp85_r1i1p1_185001-210012.nc
    ./tas_raw/tas_Amon_IPSL-CM5B-LR_historical+rcp85_r1i1p1_185001-210012.nc
    ./tas_raw/tas_Amon_MIROC5_historical+rcp85_r1i1p1_185001-210012.nc
    ./tas_raw/tas_Amon_MIROC5_historical+rcp85_r2i1p1_185001-210012.nc
    ./tas_raw/tas_Amon_MIROC5_historical+rcp85_r3i1p1_185001-210012.nc
    ./tas_raw/tas_Amon_MIROC-ESM-CHEM_historical+rcp85_r1i1p1_185001-210012.nc
    ./tas_raw/tas_Amon_MIROC-ESM_historical+rcp85_r1i1p1_185001-210012.nc
    ./tas_raw/tas_Amon_MPI-ESM-LR_historical+rcp85_r1i1p1_185001-230012.nc
    ./tas_raw/tas_Amon_MPI-ESM-LR_historical+rcp85_r2i1p1_185001-210012.nc
    ./tas_raw/tas_Amon_MPI-ESM-LR_historical+rcp85_r3i1p1_185001-210012.nc
    ./tas_raw/tas_Amon_MPI-ESM-MR_historical+rcp85_r1i1p1_185001-210012.nc
    ./tas_raw/tas_Amon_MRI-CGCM3_historical+rcp85_r1i1p1_185001-210012.nc
    ./tas_raw/tas_Amon_NorESM1-ME_historical+rcp85_r1i1p1_185001-210012.nc
    ./tas_raw/tas_Amon_NorESM1-M_historical+rcp85_r1i1p1_185001-210012.nc

    The filenames follow the general convention used by CMIP5 and should be
    relatively self-explanatory.  The total data volume is on the order of
    32 GB.

# Instructions

1. Make '1.calculate_global_mean_and_Greenland_tas.sh' executable and run it. This generates timeseries of yearly Greenland-mean and global-mean surface air temperature for each model run for the period 1970-2099. For those models with extended runs, timeseries are also generated for the period 1970-2299.

2. Make '2.create_multiple_timeseries_and_amplification_plots.R' executable and run it.  This calculates the "Greenland amplification" for each model run and generates Figure 4.


 
 
