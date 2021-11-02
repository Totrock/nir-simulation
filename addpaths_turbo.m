clear;
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

% 0 -> display no figures
% 1 -> display generated images
% 2 -> also display meshes and preview
global DISPLAY_FIGURES;
DISPLAY_FIGURES = 2;

%% create default values                   
%mmc 90deg
%    detpos = [x_mm/2-detsize/2+2  y_mm/2-detsize/2 1.2];
%    detdef = struct('srctype','planar',
%                  'srcpos',detpos,
%                  'srcdir',[0 0 0],
%                  'srcparam1',[detsize 0 0],
%                  'srcparam2',[0 detsize 0]);



%mcx_input.prop=[0 0 1 1;
%                0.1 2.867 0.99 1.63;
%                0.35 22.193 0.83 1.49;          
%                0.35 22.193 0.83 1.49;          
%                0.35 22.193 0.83 1.49]; %water?!

% for mcxcl
% mcxlab(cfg,'opencl');
addpath('/home/probst/bin/mcx/mcxcl/mcxlabcl/');