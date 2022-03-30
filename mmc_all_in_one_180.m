%%%
%%% this script does not call another script written by me
%%% basically the code for one simulation as spaghetti-code
%%%
clear all;

% IMPORTANT IMPORTANT IMPORTANT IMPORTANT IMPORTANT
% FIRST configure a path to a segmented tooth here:
filename = '/home/probst/data/molar/Z_209_C0005777.raw rotated_256.mhd';
% AND copy the correct paths for iso2mesh and mmc here:
addpath(genpath('../bin/iso2mesh/'));
addpath(genpath('../bin/mcx/mmc'));

% now you can run a simulation without the kollimator and a large source
% and afterwards one with the kollimator and a small source

config = 2;

if config == 1
  kollimator = false;
  kollimator_threshold = 0.98
  number_of_photons = 1e7;
  radius_of_source_disk = 9; %mm
end
if config == 2
  kollimator = true;
  kollimator_threshold = 0.98
  number_of_photons = 1e8;
  radius_of_source_disk = 1; %mm
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% add paths
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% on a server with x2go we have to use another toolkit
graphics_toolkit("fltk");
% the package used for reading mhd/mha files
addpath(genpath("./read3d/"))
% these folders contain helper functions or data
addpath(genpath("./utils/"))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

volume = mha_read_volume(filename);
volume = cast(volume,'uint8');

% the original µCT has 1024 voxel in x-axis where 1 voxel is 0.02 mm
% due to downsampling unitinmm is slightly wrong for the z-axis TODO?
[x,y,z] = size(volume);
unitinmm = (1024 / x) * 0.02;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% remove all layers around the tooth which are only background
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
arr = [];
for xx = [1:x]
  arr = [arr ismember(0,(unique(volume(xx,:,:)) == 0))];
end
volume = volume(logical(arr),:,:);
arr = [];
for yy = [1:y]
  arr = [arr ismember(0,(unique(volume(:,yy,:)) == 0))];
end
volume = volume(:,logical(arr),:);
arr = [];
for zz = [1:z]
  arr = [arr ismember(0,(unique(volume(:,:,zz)) == 0))];
end
volume = volume(:,:,logical(arr));

[x,y,z] = size(volume);

x_mm = unitinmm * x;
y_mm = unitinmm * y;
z_mm = unitinmm * z;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% set up source and detector
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

src_radius = radius_of_source_disk;
srcdir = [-1 0 0];
srcdir = srcdir/norm(srcdir);
srcpos = [x_mm+2 y_mm/2+0.5 z_mm/4*3+0.5];
srcparam1 = [src_radius 0 0];
srcdef=struct('srctype','disk',
              'srcpos',srcpos,
              'srcdir',srcdir,
              'srcparam1',srcparam1);  

detpos = [-1 0 0];
detdef =struct('srctype','planar',
              'srcpos',detpos,
              'srcdir',[1 0 0],
              'srcparam1',[0 y_mm+1 0],
              'srcparam2',[0 0 z_mm+1]);
              
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% create mesh
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     
% maximum node volume. Increasing this value should
% create larger tetrahedra in the centre of an image region.
triangVolume = 100; % I used  [10 - 1000]
opt.distbound=2;    % set max distance that deviates from the level-set, I used [1 - 4]
opt.radbound=2;     % set surface triangle maximum size perv, I used [1 - 4]
opt.autoregion=0;   % don't save interior points
opt.A = diag([unitinmm,unitinmm,unitinmm]); % include voxel size in mm as scaling matrix
opt.B = zeros(3,1); % no translation

% create a mesh from the volume
[node, elem, face] = v2m(volume, 1:max(volume(:)), opt, triangVolume, 'cgalmesh');

% cut off redundant information
node = node(:,1:3);

% add a source
[node,elem]=mmcaddsrc(node,elem,srcdef);

% add a detector
[node,elem]=mmcadddet(node,elem,detdef);

% display meshes
tooth_mesh_figure1 = figure('name','mesh of the simulation');
plotmesh(node, elem);
colorbar;

tooth_mesh_figure2 = figure('name','mesh without the convex hull');
plotmesh(node, elem(elem(:,5)~=0,:));
colorbar;
colormap ('rainbow');

tooth_mesh_figure3 = figure('name','just the mesh of the tooth');
plotmesh(node, elem(elem(:,5)>0,:));
colorbar;
colormap ('rainbow');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% configure simulation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cfg.nphoton = number_of_photons;
cfg.prop = [0 0 1 1;
           0.1 2.867 0.99 1.63;
           0.35 22.193 0.83 1.49;          
           0.0025 1.5 0.77 1.39];
           
cfg.gpuid='1';
cfg.maxdetphoton = cfg.nphoton;
cfg.node = node;
cfg.elem = elem;

% copy the source-definition from before
cfg.srctype=srcdef.srctype;
cfg.srcpos=srcdef.srcpos;
cfg.srcdir=srcdef.srcdir;
cfg.srcparam1=srcdef.srcparam1;

cfg.detpos = [detdef.srcpos 1];

% the 5th col of elem contains information about which region the tetrahedron is assigned to 
% this has to be copied to elemprop
% elem has to have 4 cols 
cfg.elemprop=cfg.elem(:,5);
cfg.elem=cfg.elem(:,1:4);

% 1e-5 seconds is plenty of time for our scenario
cfg.tstart=0;
cfg.tend=1e-5;
cfg.tstep=1e-5;

% save surface diffuse reflectance
cfg.issaveref=1;  

% save photons which hit a detector
cfg.issaveexit = 1; 

cfg.isreflect = 1;


% run the simulation
[flux,detphoton] = mmclab(cfg);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% create an image from the detected photons
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

biny = int16(sum(detdef.srcparam1)*20);
binx = int16(sum(detdef.srcparam2)*20);

opts.filterV = kollimator;

% extract detphoton
if(isfield(detphoton,'p'))
  p = detphoton.p;
end
if(isfield(detphoton,'v'))
  v = detphoton.v;
end

% calculate the weight of each photon
detw=mmcdetweight(detphoton, detphoton.prop, unitinmm);

% find out in which plane the detector is
% and reduce the information about where the photon hit the detector
% from 3D to 2D i.e. (xyz to xy/yz/xz)
if detdef.srcdir(1) == 1  
  p = [p(:,2) p(:,3)];
  v_dir = 1;
elseif detdef.srcdir(2) == 1
  p = [p(:,1) p(:,3)];
  v_dir = 2;
else
  p = [p(:,1) p(:,2)];
  v_dir = 3;
end

%%%%%%%%%%%%%%%%%%%%
% ignore all photons that hit the detector in a 90° angle
%%%%%%%%%%%%%%%%%%%%
if opts.filterV
  v_idx1 = abs(v(:,v_dir)) != 1;
  v = v(v_idx1,:);
  p = p(v_idx1,:);
  detw = detw(v_idx1,:);
end
%%%%%%%%%%%%%%%%%%%%
% kind of a Collimator
% filters out all photons which do not hit the detector almost orthogonally
%%%%%%%%%%%%%%%%%%%%
if opts.filterV
  v_idx2 = abs(v(:,v_dir)) > kollimator_threshold;
  v = v(v_idx2,:);
  p = p(v_idx2,:);
  detw = detw(v_idx2,:);
end

% create empty image
im = zeros(biny, binx);
% sort the photons into a grid and add the weights to each bin
[r_edges, c_edges] = edges_from_nbins(p, [binx biny]);
r_idx = lookup (r_edges, p(:,1), "l");
c_idx = lookup (c_edges, p(:,2), "l");
for j = 1:length(r_idx)
  im(c_idx(j), r_idx(j)) += detw(j);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% crop, save and display the image
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     
im = im(2:biny-1, 2:binx-1);

im_norm=(im-min(im(:)))/(max(im(:))-min(im(:)));
im_norm = im_norm * 65535;
im_norm = uint16(im_norm);
imwrite(im_norm, strcat('all-in-one-demo-mmc','-raw.png'));

im_log = log(im);
im_log(im_log==-Inf) = -10;
im_log_norm=(im_log-min(im_log(:)))/(max(im_log(:))-min(im_log(:)));
im_log_norm = im_log_norm * 65535;
im_log_norm = uint16(im_log_norm);
imwrite(im_log_norm, strcat('all-in-one-demo-mmc','-log.png'));

tooth_figure = figure('name',strcat('all-in-one-demo-mmc:', int2str(cfg.isreflect)));
imagesc(log(im));
colorbar;

