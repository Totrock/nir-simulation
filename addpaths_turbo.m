clear all;
% adds files in these directories to the search path of octave
% genpath means all subdirectories
addpath(genpath('../bin/iso2mesh/'));
addpath(genpath('../bin/mcx/mmc'));
addpath(genpath('../bin/mcx/MCXStudio/MCXSuite/mmc'));
addpath(genpath('../bin/mcx/MCXStudio/MCXSuite/mcx/utils'));
addpath(genpath('../bin/mcx/mcx/mcxlab'));

% on a server with x2go we have to use one of these two toolkits
graphics_toolkit("fltk");
%graphics_toolkit("gnuplot");

% the package used for reading mhd/mha files
addpath(genpath("./read3d/"))

% these folders contain helper functions or data
addpath(genpath("./utils/"))
addpath(genpath("./simple_scenarios"))
addpath(genpath("./data"))

% this declares a global variable which can be available in all scripts
% it just configures whether the scripts open certain images as figures
% 0 -> display no figures
% 1 -> display generated images
% 2 -> also display meshes and preview
global DISPLAY_FIGURES;
DISPLAY_FIGURES = 1;

% pkg load statistics;

% If one wants to use the opencl variant of mcx (mcxcl) use this line
% mcxlab(cfg,'opencl');
addpath('/home/probst/bin/mcx/mcxcl/mcxlabcl/');