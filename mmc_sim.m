addpath(genpath('../MCXStudio/MATLAB'));
addpath(genpath('../MCXStudio/MCXSuite/mmc/matlab'));
addpath(genpath('../MCXStudio/MCXSuite/mcxcl/utils'));
addpath(genpath('../iso2mesh/'));

clear cfg

unitinmm=(1024 / v1) * 0.02;

% define the source
cfg.srctype='pencil';
cfg.srcpos=[unitinmm*x/2 unitinmm*1 unitinmm*z*5/8];
srcdir = [0 1 0];
srcdir = srcdir/norm(srcdir);
cfg.srcdir=srcdir;
%cfg.srcparam1=5;
%cfg.srcparam2=0;

cfg.nphoton=1e7;

volume_for_mesh = volume;
volume_for_mesh(volume_for_mesh == 1) = 0;
volume_for_mesh(volume_for_mesh == 0) = 1;

% maximum node volume. Increasing this value should
% create larger tetrahedra in the centre of an image region.
triangVolume = 1000;

% option struct
clear opt;
opt.distbound=1;    % set max distance that deviates from the level-set
opt.radbound=4;      % set surface triangle maximum size
opt.autoregion=0;     % don't save interior points
opt.A = diag([unitinmm,unitinmm,unitinmm]); % include voxel size in mm as scaling matrix
opt.B = zeros(3,1); % no translation

[node, elem, face] = v2m(volume_for_mesh, [], opt, triangVolume, 'cgalmesh');

mesh_plotted = figure;
plotmesh(node,face,elem);

cfg.node = node;
cfg.elem = elem;
                     
% I STILL HAVE TO CHECK WHAT THIS DOES
% elem and node have to have the correct dimensions
% used this as reference: https://github.com/fangq/mmc/blob/master/examples/skinvessel/createsession.m
cfg.elemprop=cfg.elem(:,5);
cfg.elem=cfg.elem(:,1:4);
cfg.node=cfg.node(:,1:3);

cfg.prop=[0 0 1 1;
          0 0 1 1;
          0.1 2.867 0.99 1.63;
          0.35 22.193 0.83 1.49;          
          2.8 0 1 1.333]; %water?!
cfg.tstart=0;
cfg.tend=5e-9;
cfg.tstep=5e-9;
cfg.debuglevel='TP';
cfg.issaveref=1;  % in addition to volumetric fluence, also save surface diffuse reflectance


%% Use this line to create a json config and many binary files to use mmc directly
%mmc2json(cfg, 'mmc_cfg_octave')

%% run the simulation
[fluence,detphoton,ncfg,seeds]=mmclab(cfg);

%% plotting the result

%% plot the cross-section of the fluence
% subplot(121);
% plotmesh([cfg.node(:,1:3),log10(abs(fluence.data(1:size(cfg.node,1))))],cfg.elem,'y=30','facecolor','interp','linestyle','none')
% view([0 1 0]);
% colorbar;

%% plot the surface diffuse reflectance

mesh_diffuse_reflectance_plotted = figure;

if(isfield(cfg,'issaveref') && cfg.issaveref==1)
    subplot(111);
    faces=faceneighbors(cfg.elem,'rowmajor');
    hs=plotmesh(cfg.node,faces,'cdata',log10(fluence.dref(:,1)),'linestyle','none');
    colorbar;
end
