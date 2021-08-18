addpath(genpath('../MCXStudio/MATLAB'));
addpath(genpath('../MCXStudio/MCXSuite/mmc/matlab'));
addpath(genpath('../MCXStudio/MCXSuite/mcxcl/utils'));
addpath(genpath('../iso2mesh/'));


cfg.nphoton=1e6;
[cfg.node face cfg.elem]=meshabox([0 0 0],[60 60 30],6);
cfg.elemprop=ones(size(cfg.elem,1),1);
cfg.srcpos=[30 30 0];
cfg.srcdir=[0 0 1];
cfg.prop=[0 0 1 1;0.005 1 0 1.37];
cfg.tstart=0;
cfg.tend=5e-9;
cfg.tstep=5e-10;
cfg.debuglevel='TP';
%cfg.method='havel';
% preprocessing to populate the missing fields to save computation
ncfg=mmclab(cfg,'prep');

cfgs(1)=ncfg;   % when using struct array input, all fields must be defined
cfgs(2)=ncfg;
cfgs(1).isreflect=0;
cfgs(2).isreflect=1;
cfgs(2).detpos=[30 20 0 1;30 40 0 1;20 30 1 1;40 30 0 1];
% calculate the fluence and partial path lengths for the two configurations
[fluxs,detps]=mmclab(cfgs);