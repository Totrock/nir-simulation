function [node, elem, detdef, srcdef] = create_mesh(volume, srcdef, detdef, unitinmm)
  global DISPLAY_FIGURES;

  [x,y,z] = size(volume);
  x_mm = unitinmm * x;
  y_mm = unitinmm * y;
  z_mm = unitinmm * z;

  % prepare the volume, so that it is completly enclosed in 0s
  volume(volume == 0) = 1;
  volume = volume - 1;

%   maximum node volume. Increasing this value should
%   create larger tetrahedra in the centre of an image region.
   triangVolume = 1000;

%   option struct
    opt.distbound=1;    % set max distance that deviates from the level-set
    opt.radbound=1;      % set surface triangle maximum size
    opt.autoregion=0;     % don't save interior points
    opt.A = diag([unitinmm,unitinmm,unitinmm]); % include voxel size in mm as scaling matrix
    opt.B = zeros(3,1); % no translation

  [node, elem, face] = v2m(volume, 1:max(volume(:)), opt, triangVolume, 'cgalmesh');

%%  [node,elem,face]=vol2mesh(volume>0.05,1:size(volume,1),1:size(volume,2),1:size(volume,3),2,2,1);

%% [node,elem,face]=vol2mesh(volume>0.05,1:size(volume,1),1:size(volume,2),1:size(volume,3),0.2,2,1,'simplify');

  % save data.mat node elem x_mm y_mm z_mm;
  if DISPLAY_FIGURES > 1
    tooth = figure;
    plotmesh(node, elem);
    colorbar;
  endif

  % the information in the 4th col of node is duplicated in elem 5th col (I think)
  node = node(:,1:3);

  [node,elem]=mmcaddsrc(node,elem,srcdef);

  if DISPLAY_FIGURES > 1
    tooth_src = figure;
    plotmesh(node, elem);
    colorbar;
  endif
  
  % srcdir is irrelevant for the detector, but must be defined nevertheless
  % planar will create a rectangle defined by 4 corners srcpos, srcpos+srcparam1, srcpos+srcparam2, srcpos+srcparam1+srcparam2
  % it has to be called src...
    
  [node,elem]=mmcadddet(node,elem,detdef);

  if DISPLAY_FIGURES > 1
    tooth_det = figure;
    plotmesh(node, elem);
    colorbar;
  end
  

  % the created mesh is now in mm
  % so basically this is true: unitinmm = 1;
end




