function [node, elem, detdef, srcdef] = create_mesh(volume, srcdef, detdef, unitinmm, detdef2)
  global DISPLAY_FIGURES;

  [x,y,z] = size(volume);
  x_mm = unitinmm * x;
  y_mm = unitinmm * y;
  z_mm = unitinmm * z;

  % prepare the volume, so that it is completly enclosed in 0s
  volume(volume == 0) = 1;
  volume = volume - 1;

  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% configure the folloing parameters to alter the mesh generation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % maximum node volume. Increasing this value should
  % create larger tetrahedra in the centre of an image region.
  triangVolume = 10; % I used  [10 - 1000]

  opt.distbound=1;    % set max distance that deviates from the level-set, I used [1 - 4]
  opt.radbound=1;     % set surface triangle maximum size perv, I used [1 - 4]
  opt.autoregion=0;   % don't save interior points
  opt.A = diag([unitinmm,unitinmm,unitinmm]); % include voxel size in mm as scaling matrix
  opt.B = zeros(3,1); % no translation
  
  % create a mesh from the volume
  [node, elem, face] = v2m(volume, 1:max(volume(:)), opt, triangVolume, 'cgalmesh');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  % cut off redundant information
  node = node(:,1:3);

  % If you want to export the mesh data use the following line
  % save data.mat node elem x_mm y_mm z_mm;
  
  if DISPLAY_FIGURES > 1
    % display the tooth without the convex hull
    tooth_mesh_figure = figure('name','mesh of the tooth');
    plotmesh(node, elem(elem(:,5)>0,:));
    colorbar;
    colormap ('rainbow');
    % display only dentin and pulp
    tooth_mesh_figure = figure('name','mesh of tooth without enamel');
    plotmesh(node(:,1:3), elem(elem(:,5)>1,:));
    colorbar;
    colormap ('rainbow');
    % display only the pulp
    tooth_mesh_figure = figure('name','mesh of pulp');
    plotmesh(node(:,1:3), elem(elem(:,5)>2,:));
    colorbar;
    colormap ('rainbow');
  endif

  
  % add a source
  [node,elem]=mmcaddsrc(node,elem,srcdef);
  % display the tooth without the convex hull but with tetrahedron of the source
  if DISPLAY_FIGURES > 1
    tooth_mesh_figure = figure('name','mesh of the tooth');
    plotmesh(node, elem(elem(:,5)~=0,:));
    colorbar;
    colormap ('rainbow');
  end
  % display the complete current mesh
  if DISPLAY_FIGURES > 1
    tooth_src = figure;
    plotmesh(node, elem);
    colorbar;
  end
  
  % add a detector
  [node,elem]=mmcadddet(node,elem,detdef);
  if DISPLAY_FIGURES > 1
    tooth_det = figure;
    plotmesh(node, elem);
    colorbar;
  end
  
  % add second detector if it was given as a parameter
  if nargin > 4
    [node,elem]=mmcadddet(node,elem,detdef2);
    if DISPLAY_FIGURES > 1
      tooth_det = figure;
      plotmesh(node, elem);
      colorbar;
    end
  end

  % the created mesh is now in mm
  % so unitinmm is equal to 1
end