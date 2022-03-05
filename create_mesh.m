function [node, elem, detdef, srcdef] = create_mesh(volume, srcdef, detdef, unitinmm, detdef2)
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
%   triangVolume = 1000;
   triangVolume = 100;

%   option struct
    opt.distbound=1;    % set max distance that deviates from the level-set
    opt.radbound=4;      % set surface triangle maximum size perv 4
%    opt.radbound=1;      % set surface triangle maximum size
    opt.autoregion=0;     % don't save interior points
    opt.A = diag([unitinmm,unitinmm,unitinmm]); % include voxel size in mm as scaling matrix
    opt.B = zeros(3,1); % no translation

  [node, elem, face] = v2m(volume, 1:max(volume(:)), opt, triangVolume, 'cgalmesh');
  
  node = node(:,1:3);

  
  % If you want to export the mesh data use the following line
  % save data.mat node elem x_mm y_mm z_mm;
  
  % view only dentin or pulp
  if DISPLAY_FIGURES > 1
    tooth_mesh_figure = figure('name','mesh of the tooth');
    plotmesh(node, elem(elem(:,5)>0,:));
    colorbar;
    colormap ('rainbow');
    
    tooth_mesh_figure = figure('name','mesh of tooth without enamel');
    plotmesh(node(:,1:3), elem(elem(:,5)>1,:));
    colorbar;
    colormap ('rainbow');
   
    tooth_mesh_figure = figure('name','mesh of pulp');
    plotmesh(node(:,1:3), elem(elem(:,5)>2,:));
    colorbar;
    colormap ('rainbow');
  endif

  

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
  
  if nargin > 4
    [node,elem]=mmcadddet(node,elem,detdef2);

    if DISPLAY_FIGURES > 1
      tooth_det = figure;
      plotmesh(node, elem);
      colorbar;
    end
  end

  % the created mesh is now in mm
  % so basically this is true: unitinmm = 1;
end