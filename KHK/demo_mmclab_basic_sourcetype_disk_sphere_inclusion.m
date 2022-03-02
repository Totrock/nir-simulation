%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MMCLAB - Mesh-based Monte Carlo for MATLAB/Octave by Qianqina Fang
% KHK composed with copy and paste from mmclab/example
%     demo_mmclab_basic.m
%     demo_example_meshtest.m
%
% todo: Detektor ergänzen!
%           

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%-----------------------------------------------------------------
% preparation
%%-----------------------------------------------------------------

clear;
addpaths_turbo;
%addpaths_khk; % add paths to mmc, mcx and iso2mesh including their subdirectories
pkg load statistics;

% on a server with x2go we have to use one of these two toolkits
graphics_toolkit("fltk");
%graphics_toolkit("gnuplot");

% create a surface mesh for a 10mm radius sphere
[no,el]=meshasphere([30 30 30],15,1.0);

%%-----------------------------------------------------------------
%% create the common parameters for simulation
%%-----------------------------------------------------------------

clear cfg
cfg.nphoton=1e6;
srcdir = [0 0 1];
cfg.srcdir = srcdir/norm(srcdir);
cfg.srcpos = [30 30 0];

## optical properties
%% cfg.prop=[0 0 1 1;0.002 1.0 0.01 1.37;0.050 5.0 0.9 1.37];

  % The loaded images are /(should be) coded in the following way:
  % padding / outer-most-layer = 0 TODO dont do this in preprocessing
  % background = 1
  % enamel = 2
  % dentin = 3

cfg.prop = [0 0 1 1;
           0.04 0.5 0.9 1.633;
           0.15 6.6 0.96 1.54]; 

cfg.tstart=0;
cfg.tend=5e-9;
cfg.tstep=5e-9;
cfg.debuglevel='TP';
cfg.issaveref=1;  % in addition to volumetric fluence, also save surface diffuse reflectance
cfg.isreflect=0;
cfg.method='elem';

%%-----------------------------------------------------------------
%% tetrahedral mesh generation
%%-----------------------------------------------------------------

srcpos=[30. 30. 0.];
fixednodes=[30.,30.,0.05; 30 30 30];
nfull=[no;fixednodes];

## use either coarse or dense volumetric mesh
##
##% generate a coarse volumetric mesh from the sphere with an additional bounding box
##% the maximum element volume is 20
##nodesize=[ones(size(no,1),1) ; 0.5; 3];
##[cfg.node,cfg.elem,face]=surf2mesh([nfull,nodesize],el,[0 0 0],[60.1 60.1 60.1],1,8,[30 30 30],[],[1.5 1.5 1.5 1.5 5 5 5 5]);

% generate a dense volumetric mesh from the sphere with an additional bounding box
% the maximum element volume is 5
nodesize=[1*ones(size(no,1),1) ; 1; 1];
[cfg.node,cfg.elem,face]=surf2mesh([nfull,nodesize],el,[0 0 0],[60.1 60.1 60.1],1,2,[30 30 30],[],[1 1 1 1 1 1 1 1]);

# check frequencies of cfg.elem(:,5);
tabulate(cfg.elem(:,5))

%%

[cfg.node,cfg.elem]=sortmesh(srcpos,cfg.node,cfg.elem,1:4);

cfg.elem(:,5)=cfg.elem(:,5)+1;
cfg.elemprop=cfg.elem(:,5);

# check frequencies of elemprop
tmp=[cfg.elem(:,1:4),cfg.elemprop(:,1)];
tabulate(tmp(:,5))

%%-----------------------------------------------------------------
## source
%%-----------------------------------------------------------------

cfg.srctype='disk';
cfg.srcparam1=[10 0 0 0]; % size is limited currently

%% define wide-field disk source by extending the mesh to the widefield src
srcdef=struct('srctype',cfg.srctype,'srcpos',cfg.srcpos,'srcdir',cfg.srcdir,...
    'srcparam1',cfg.srcparam1,'srcparam2',[]);
    
## add source to existing mesh
[cfg.node,cfg.elem] = mmcaddsrc(cfg.node,[cfg.elem cfg.elemprop],...
    mmcsrcdomain(srcdef,[min(cfg.node);max(cfg.node)]));
cfg.elemprop=cfg.elem(:,5);    
cfg.elem=cfg.elem(:,1:4);

##figure;
##plotmesh(cfg.node(:,1:3),[cfg.elem(:,1:4),cfg.elemprop(:,1)])

# check frequencies of elemprop
tmp=[cfg.elem(:,1:4),cfg.elemprop(:,1)];
tabulate(tmp(:,5))


%%-----------------------------------------------------------------
%% run the simulation
%%-----------------------------------------------------------------

flux=mmclab(cfg);

%% plotting the result

% plot the cross-section of the fluence
figure;
subplot(121);
title('xz plan at y=30')
plotmesh([cfg.node(:,1:3),log10(abs(flux.data(1:size(cfg.node,1))))],cfg.elem,'y=30','facecolor','interp','linestyle','none')
view([0 1 0]);
colorbar;

% plot the surface diffuse reflectance
if(isfield(cfg,'issaveref') && cfg.issaveref==1)
    subplot(122);
    faces=faceneighbors(cfg.elem,'rowmajor');
    hs=plotmesh(cfg.node,faces,'cdata',log10(flux.dref(:,1)),'linestyle','none');
    colorbar;
end

figure;
subplot(321)
title('xy plan at z=10')
plotmesh([cfg.node(:,1:3),log10(abs(flux.data(1:size(cfg.node,1))))],cfg.elem,'z=10','facecolor','interp','linestyle','none')
view([0 0 1]);

subplot(322)
title('xy plan at z=20')
plotmesh([cfg.node(:,1:3),log10(abs(flux.data(1:size(cfg.node,1))))],cfg.elem,'z=20','facecolor','interp','linestyle','none')
view([0 0 1]);

subplot(323)
title('xy plan at z=30')
plotmesh([cfg.node(:,1:3),log10(abs(flux.data(1:size(cfg.node,1))))],cfg.elem,'z=30','facecolor','interp','linestyle','none')
view([0 0 1]);

subplot(324)
title('xy plan at z=40')
plotmesh([cfg.node(:,1:3),log10(abs(flux.data(1:size(cfg.node,1))))],cfg.elem,'z=40','facecolor','interp','linestyle','none')
view([0 0 1]);

subplot(325)
title('xy plan at z=50')
plotmesh([cfg.node(:,1:3),log10(abs(flux.data(1:size(cfg.node,1))))],cfg.elem,'z=50','facecolor','interp','linestyle','none')
view([0 0 1]);

subplot(326)
title('xy plan at z=60')
plotmesh([cfg.node(:,1:3),log10(abs(flux.data(1:size(cfg.node,1))))],cfg.elem,'z=60','facecolor','interp','linestyle','none')
view([0 0 1]);


