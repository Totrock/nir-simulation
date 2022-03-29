addpaths_turbo;
%
% this script will open a figure with the mesh of the tooth
%
tooth_dir = '/home/probst/data/praemolar/';
files = dir(tooth_dir);
for file = files'
  % if "5776" is removed from the next line the script will go through all
  % mhd files which have been rotated and a resoltion of 256
    if regexp(file.name, '5776.raw rotated_256*.mhd') 
      filename = strcat(tooth_dir, file.name);
      
      [volume, unitinmm] = load_data(filename);
      volume = rotdim (volume, 1, [1, 3]);
      volume = rotdim (volume, 1, [2, 3]);
      volume = rotdim (volume, 3, [1, 2]);
      volume = volume + 1;

      [x,y,z] = size(volume);

      x_mm = unitinmm * x;
      y_mm = unitinmm * y;
      z_mm = unitinmm * z;

      volume(volume == 0) = 1;
      volume = volume - 1;
      % change these parameters for different accuracy
      triangVolume = 100;
      opt.distbound=2;
      opt.radbound=2;  
      opt.autoregion=0; 
      opt.A = diag([unitinmm,unitinmm,unitinmm]); 
      opt.B = zeros(3,1);

      [node, elem, face] = v2m(volume, 1:max(volume(:)), opt, triangVolume, 'cgalmesh');

      tooth_mesh_figure = figure('name',strcat('',file.name),'position',[100,100,1200,1000]);
      colormap ('rainbow');
      colorbar();
      plotmesh(node, elem);
  end
end