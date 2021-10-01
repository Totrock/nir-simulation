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

% we use functions of this for visualisation
pkg load statistics;