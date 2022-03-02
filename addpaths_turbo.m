clear all;
addpath(genpath('../bin/iso2mesh/'));
addpath(genpath('../bin/mcx/mmc'));
addpath(genpath('../bin/mcx/MCXStudio/MCXSuite/mmc'));
addpath(genpath('../bin/mcx/MCXStudio/MCXSuite/mcx/utils'));

% for self-compiled mcxlab
addpath(genpath('../bin/mcx/mcx/mcxlab'));


% on a server with x2go we have to use one of these two toolkits
graphics_toolkit("fltk");
%graphics_toolkit("gnuplot");

% for reading mhd/mha files
addpath(genpath("./read3d/"))

% for getting default values
addpath(genpath("./utils/"))
addpath(genpath("./simple_scenarios"))
addpath(genpath("./data"))

% 0 -> display no figures
% 1 -> display generated images
% 2 -> also display meshes and preview
global DISPLAY_FIGURES;
DISPLAY_FIGURES = 2;


% for mcxcl
% mcxlab(cfg,'opencl');
addpath('/home/probst/bin/mcx/mcxcl/mcxlabcl/');