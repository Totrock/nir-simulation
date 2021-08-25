addpath(genpath('../iso2mesh/'));
addpath(genpath('../MCXStudio/MATLAB'));
addpath(genpath('../MCXStudio/MCXSuite/mmc/matlab'));
addpath(genpath('../MCXStudio/MCXSuite/mcxcl/utils'));

volume_for_mesh = volume;
% prepare the volume, so that it is completly enclosed in 0s
volume_for_mesh(volume_for_mesh == 1) = 0;
volume_for_mesh = volume_for_mesh - 1;


clear opt node face elem triangVolume;

%% ok parameters (for now) for iso2mesh according to Prof. Roesch

% maximum node volume. Increasing this value should
% create larger tetrahedra in the centre of an image region.
triangVolume = 1000;

% option struct
opt.distbound=1;    % set max distance that deviates from the level-set
opt.radbound=4;      % set surface triangle maximum size
opt.autoregion=0;     % don't save interior points
opt.A = diag([unitinmm,unitinmm,unitinmm]); % include voxel size in mm as scaling matrix
opt.B = zeros(3,1); % no translation

[node, elem, face] = v2m(volume_for_mesh, [], opt, triangVolume, 'cgalmesh');

% the information in the 4th col of node is duplicated in elem 5th col (I think)
node = node(:,1:3);

% srcdir is irrelevant for the detector, but must be defined nevertheless
% planar will create a rectangle defined by 4 corners srcpos, srcpos+srcparam1, srcpos+srcparam2, srcpos+srcparam1+srcparam2
% it has to be called src...
detdef=struct('srctype','planar',
              'srcpos',[unitinmm y_mm/2 z_mm/2],
              'srcdir',[0 0 0],
              'srcparam1',[0 2 0],
              'srcparam2',[0 0 2]);
              
[node_w_det,elem_w_det]=mmcadddet(node,elem,detdef);


srcdir = [-1 0 0];
srcdir = srcdir/norm(srcdir);
srcdef=struct('srctype','disk',
                'srcpos',[x_mm y_mm/2 z_mm/2],
                'srcdir',srcdir,
                'srcparam1',[1 0 0]);            

[newnode,newelem]=mmcaddsrc(node_w_det,elem_w_det,srcdef);

%tooth_fig = figure;
%plotmesh(node,elem);
%
%tooth_det = figure;
%plotmesh(node_w_det,elem_w_det);
%
%tooth_det_src = figure;
%plotmesh(newnode,newelem);


clear opt face ans srcdir tooth_det_src tooth_fig tooth_det triangVolume node elem node_w_det elem_w_det;













