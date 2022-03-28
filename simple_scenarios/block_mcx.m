addpaths_turbo;

svmc = 1;
mcx_input.nphoton = 4e7;

% load the block prepared in python
% the whole thing is 256**3
% the cube in the middle is 128**3
filename = 'block.mhd';
[volume, unitinmm] = load_data(filename);
[x,y,z] = size(volume);

% currently the background is 0 and enamel is 1...
% add one to every voxel, set all 1 to 0
% set the space between source and block to 1, so that it is traversable
volume = volume + 1;
volume(volume == 1) = 0;
volume(x-64:x, :, :) = 1;


%prepare parameters
mcx_input.prop = [0 0 1 1;      % 0-Voxel Detector / Border of Simulation
           0 0 1 1;             % 1-Voxel Air
           0.1 2.867 0.99 1.63;  % 2-Voxel Enamel (Top-Right in Image)
           0.1 2.867 0.99 1.63;  % 3-Voxel Enamel (Bottom-Right in Image)
           0.35 22.193 0.83 1.49; % 4-Voxel Dentin (Bottom-Left in Image)
           0.0025 1.5 0.77 1.39]; % 5-Voxel Pulp (Top-Left in Image)
           
           
% set up src and detector            
srcdef.srctype = 'disk';
srcdef.srcpos = [x x/2 x/2];
srcdef.srcdir = [-1 0 0];
srcdef.srcparam1 = 90;
detpos = [65 x/2 x/2 90];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% activate these 2 lines to run mcx in svmc mode
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if svmc
  [volume]=mcxsvmc_octave(volume);
  volume = cast(volume,'uint8');
end

% run the simulation
detphoton = mcx_sim(volume, unitinmm, srcdef, detpos, mcx_input);

% generate image
plot_opts.unitinmm = unitinmm;
res = 150;
plot_opts.resolution = [res, res];
im = mmc_plot_by_detector(detphoton, [1 0 0], plot_opts);
% cut away 1 pixel at the border of the image
im = im(2:res-1,2:res-1);

% display and save the image
tooth_figure = figure('name',strcat('mcx block ', int2str(mcx_input.nphoton)));
imagesc(log(im));
colorbar;
create_png(im, 'mcx-block-svmc');
