clear;
addpaths_turbo;

% the whole thing is 256**3
% the cube in the middle is 128**3
filename = 'block.mhd';
[volume, unitinmm] = load_data(filename);
% currently the background is 0 and enamel is 1...
% add one to every voxel becaue create_mesh will subtract 1
volume = volume + 1;

% prepare src and det for mesh
x_mm_block = 20.480;
y_mm_block = 20.480;
z_mm_block = 20.480;

srcdir = [-1 0 0];
srcdir = srcdir/norm(srcdir);
srcpos = [x_mm_block y_mm_block/2 z_mm_block/2];
srcparam1 = [7 0 0];
srcdef=struct('srctype','disk',
              'srcpos',srcpos,
              'srcdir',srcdir,
              'srcparam1',srcparam1); 
         
         
detsize = x_mm_block/2;
detpos = [5 y_mm_block/4+0.5 z_mm_block/4+0.5];
% srcdir is irrelevant for the detector, but must be defined nevertheless
% planar will create a rectangle defined by 4 corners; srcpos, srcpos+srcparam1, srcpos+srcparam2, srcpos+srcparam1+srcparam2
% the fieldnames of the struct have to begin with src... not det...
detdef =struct('srctype','planar',
              'srcpos',detpos,
              'srcdir',[1 0 0],
              'srcparam1',[0 detsize 0],
              'srcparam2',[0 0 detsize]); 

% generate mesh
[node, elem, detdef, srcdef] = create_mesh(volume, srcdef, detdef, unitinmm);


% prepare parameters
opts.nphoton = 1e7;
opts.prop = [0 0 1 1;           % Air
           0.1 2.867 0.99 1.63;  % Enamel (Top-Right in Image)
           0.1 2.867 0.99 1.63;  % Enamel (Bottom-Right in Image)
           0.35 22.193 0.83 1.49; % Dentin (Bottom-Left in Image)
           0.0025 1.5 0.77 1.39]; % Pulp (Top-Left in Image)
           
           
% old properties
%opts.prop = [0 0 1 1;
%           0.1 2.867 0.99 1.63;
%           0.1 2.867 0.99 1.63;
%           0.35 22.193 0.83 1.49;        
%           2.8 0 1 1.333];
           
% run simualtion
[fluence, detphoton, cfg] = mmc_sim(node, elem, detdef, srcdef, opts);

%generate image
res = 150;
plot_opts.resolution = [res, res];
im = mmc_plot_by_detector(detphoton, detdef.srcdir,plot_opts);

im = im+1;

% cut away 1 pixel at the border of the image
im = im(2:res-1,2:res-1);

% display and save the image
tooth_figure = figure('name',strcat('mmc block ', int2str(opts.nphoton)));  
imagesc(log(im));
colorbar;
create_png(im, 'mmc');

