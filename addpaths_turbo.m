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
DISPLAY_FIGURES = 1;

%% create default values                   
default_block_mcx_srcdef.srctype = 'disk';
default_block_mcx_srcdef.srcpos = [256 256/2 128];
default_block_mcx_srcdef.srcdir = [-1 0 0];
default_block_mcx_srcdef.srcparam1 = 200;

default_block_mcx_detpos = [65 256/2 256/2 90];

x_mm_block = 20.480;
y_mm_block = 20.480;
z_mm_block = 20.480;

srcdir = [-1 0 0];
srcdir = srcdir/norm(srcdir);
srcpos = [x_mm_block y_mm_block/2 z_mm_block/2];
srcparam1 = [11 0 0];
default_block_mmc_srcdef=struct('srctype','disk',
              'srcpos',srcpos,
              'srcdir',srcdir,
              'srcparam1',srcparam1); 
             
detsize = 13;
detpos = [5 y_mm_block/2-detsize/2 z_mm_block/2-detsize/2];
default_block_mmc_detdef =struct('srctype','planar',
              'srcpos',detpos,
              'srcdir',[1 0 0],
              'srcparam1',[0 detsize 0],
              'srcparam2',[0 0 detsize]); 

%mmc 90deg
##    detpos = [x_mm/2-detsize/2+2  y_mm/2-detsize/2 1.2];
##    detdef = struct('srctype','planar',
##                  'srcpos',detpos,
##                  'srcdir',[0 0 0],
##                  'srcparam1',[detsize 0 0],
##                  'srcparam2',[0 detsize 0]);



##mcx_input.prop=[0 0 1 1;
##                0.1 2.867 0.99 1.63;
##                0.35 22.193 0.83 1.49;          
##                0.35 22.193 0.83 1.49;          
##                0.35 22.193 0.83 1.49]; %water?!
