addpath(genpath('../iso2mesh/'));
addpath(genpath('../MCXStudio/MATLAB'));
addpath(genpath('../MCXStudio/MCXSuite/mmc/matlab'));
addpath(genpath('../MCXStudio/MCXSuite/mcxcl/utils'));

volume_for_mesh = volume;
volume_for_mesh(volume_for_mesh == 1) = 0;


clear opt node face elem mesh_plotted triangVolume;

% maximum node volume. Increasing this value should
% create larger tetrahedra in the centre of an image region.
triangVolume = 1000;

% option struct
opt.distbound=1;    % set max distance that deviates from the level-set
opt.radbound=4;      % set surface triangle maximum size
opt.autoregion=0;     % don't save interior points
opt.A = diag([unitinmm,unitinmm,unitinmm]); % include voxel size in mm as scaling matrix
opt.B = zeros(3,1); % no translation

[node,elem,regions,holes] = v2s(volume_for_mesh, [1,2,3], opt, 'cgalmesh');

%clear opt;
%opt.radbound = 2;
%opt.autoregion=1;
%img = volume_for_mesh;
%[node,elem,regions,holes]=vol2surf(img,1:size(img,1),1:size(img,2),1:size(img,3),opt,1,'simplify',[]);

mesh_plotted = figure;
plotmesh(node,elem);


detdef=struct('srctype','cone','srcpos',[unitinmm y_mm/2 z_mm/2],'srcdir',[1 0 0]);

%detpos=[z_mm/2 y_mm/2 unitinmm];
%detdef=struct('srctype','disk',
%                'srcpos',detpos,
%                'srcdir',[0 0 1],...
%                'srcparam1',[5*unitinmm 0 0 0]);
            
[newnode,newelem]=mmcadddet(node,elem,detdef);

mesh_plotted2 = figure;
plotmesh(node,elem);