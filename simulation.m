addpath(genpath('../MCXStudio/MATLAB'));
addpath(genpath('../MCXStudio/MCXSuite/mmc/matlab'));
addpath(genpath('../MCXStudio/MCXSuite/mcxcl/utils'));


% define the simulation
clear cfg cwdref cwfluence detpt fluence info seeds traj vol
% number of photons
cfg.nphoton=1e6;
% the previously loaded voxel-volume
cfg.vol=volume;

%cfg.vol(:,:,1)=0;   % pad a layer of 0s to get diffuse reflectance

% properties of border(0) background(1), enamel(2), dentin(3), pulp(4)
% [mua,mus,g,n] mua and mus in 1/mm

% cfg.prop=[0 0 1 1;
%           0 0 1 1;
%           1 6 0.96 1.631;
%           3.5 28 0.93 1.54;
%           2.8 0 1 1.333]; %water?!

cfg.prop=[0 0 1 1;
          0 0 1 1;
          0.1 2.867 0.99 1.63;
          0.35 22.193 0.83 1.49;          
          2.8 0 1 1.333]; %water?!

% define the source
cfg.issrcfrom0=1;
cfg.srctype='disk';
% cfg.srcpos=[v_mid v_mid 1];
cfg.srcpos=[x/2 1 z*5/8];

srcdir = [0 1 0];
srcdir = srcdir/norm(srcdir);
cfg.srcdir=srcdir;
cfg.srcparam1=5;
cfg.srcparam2=[0 0 0 0];

% define the detectors
% x, y, z, radius
% cfg.detpos=[v_mid v_mid_minus 0 5;
%             v_mid+0.5 v_mid+0.5 0 v_mid-0.5;
%             v_mid v_mid_plus 0 5;
%             v_mid_minus v_mid 0 5;
%             v_mid_plus v_mid 0 5];

cfg.savedetflag='dspmxvw';
% cfg.bc='______110110';  % capture photons existing from all faces
      
cfg.issaveref=1;

cfg.gpuid=1;
cfg.autopilot=1;
cfg.tstart=0;
cfg.tend=5e-9;
cfg.tstep=5e-10;

% original is 0.02 mm resolution with 1024*1024*517 
cfg.unitinmm = (1024 / v1) * 0.02;

% export the config to a json
%mcx2json(cfg,'cfg_from_matlab');


% calculate the fluence distribution with the given config
[fluence,detpt,vol,seeds,traj]=mcxlab(cfg);

