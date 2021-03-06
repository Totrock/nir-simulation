## Workflow step-by-step
##
## this file contains information so that it will be 
## easier in the future to reproduce the current project
##
## Reminder:
## settings for octave which are included in ~/.octaverc

#graphics_toolkit("fltk");
#addpath('~/bin/octave2021/mmc/matlab/');
#addpath('~/bin/octave2021/mmc/mmclab/');
#addpath(genpath('~/bin/octave2021/iso2mesh/'));
#pkg load statistics;

## Go with the Octave file bowser in to the directory where
## the code and data reside, i.e.
##
##    ~/bin/octave2021/nir-simulation
##
##
## open the m-files in order to be executed in the Octave GUI from left to right

edit load_data.m
edit create_mesh.m
edit mmc_sim.m
# edit load_mmc_sim_results.m
edit mmc_plot_by_detector.m


