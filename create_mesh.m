volume_for_mesh = volume;
% prepare the volume, so that it is completly enclosed in 0s
volume_for_mesh(volume_for_mesh == 0) = 1;
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
save data.mat node elem x_mm y_mm z_mm;

% the information in the 4th col of node is duplicated in elem 5th col (I think)
node = node(:,1:3);

srcdir = [-1 0 0];
srcdir = srcdir/norm(srcdir);
srcpos = [x_mm y_mm/2 z_mm/2];
srcparam1 = [1 0 0];
srcdef=struct('srctype','disk',
                'srcpos',srcpos,
                'srcdir',srcdir,
                'srcparam1',srcparam1);            

[node,elem]=mmcaddsrc(node,elem,srcdef);

% srcdir is irrelevant for the detector, but must be defined nevertheless
% planar will create a rectangle defined by 4 corners srcpos, srcpos+srcparam1, srcpos+srcparam2, srcpos+srcparam1+srcparam2
% it has to be called src...
detsize = 4;
detpos1 = [x_mm/2-detsize/2  y_mm/2-detsize/2 -1];
detdef1 = struct('srctype','planar',
              'srcpos',detpos1,
              'srcdir',[0 0 0],
              'srcparam1',[detsize 0 0],
              'srcparam2',[0 detsize 0]);

[node,elem]=mmcadddet(node,elem,detdef1);

detpos2 = [0  y_mm/2-detsize/2 z_mm/2-detsize/2];
detdef2 =struct('srctype','planar',
              'srcpos',detpos2,
              'srcdir',[0 0 0],
              'srcparam1',[0 detsize 0],
              'srcparam2',[0 0 detsize]);
  
[node,elem]=mmcadddet(node,elem,detdef2);

newelem = elem;
newnode = node;

tooth_det = figure;
plotmesh(newnode,newelem);

% the created mesh is now in mm
unitinmm = 1;

clear opt face ans srcdir tooth_det_src tooth_fig tooth_det triangVolume node elem node_w_det elem_w_det;













