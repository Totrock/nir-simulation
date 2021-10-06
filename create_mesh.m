function [node, elem, detdef, srcdef] = create_mesh(volume, srcdef, detdef, unitinmm)
  
  [x,y,z] = size(volume);
  x_mm = unitinmm * x;
  y_mm = unitinmm * y;
  z_mm = unitinmm * z;

  % prepare the volume, so that it is completly enclosed in 0s
  volume(volume == 0) = 1;
  volume = volume - 1;

  % maximum node volume. Increasing this value should
  % create larger tetrahedra in the centre of an image region.
  triangVolume = 1000;

  % option struct
  opt.distbound=1;    % set max distance that deviates from the level-set
  opt.radbound=4;      % set surface triangle maximum size
  opt.autoregion=0;     % don't save interior points
  opt.A = diag([unitinmm,unitinmm,unitinmm]); % include voxel size in mm as scaling matrix
  opt.B = zeros(3,1); % no translation

  [node, elem, face] = v2m(volume, [], opt, triangVolume, 'cgalmesh');
##  save data.mat node elem x_mm y_mm z_mm;

  % the information in the 4th col of node is duplicated in elem 5th col (I think)
  node = node(:,1:3);

  [node,elem]=mmcaddsrc(node,elem,srcdef);

  % srcdir is irrelevant for the detector, but must be defined nevertheless
  % planar will create a rectangle defined by 4 corners srcpos, srcpos+srcparam1, srcpos+srcparam2, srcpos+srcparam1+srcparam2
  % it has to be called src...
    
  [node,elem]=mmcadddet(node,elem,detdef);

  tooth_det = figure;
  plotmesh(node, elem);

  % the created mesh is now in mm
  % so basically this is true: unitinmm = 1;
end




