addpaths_turbo;

% script for the 90° scenario (DIAGNOcam) with 2 disk sources

sim_times = 2;
opts.nphoton = 1e7;
kollimator = true;

filename = '/home/probst/data/molar/Z_209_C0005777.raw rotated_256.mhd';

[volume, unitinmm] = load_data(filename);
volume = rotdim (volume, 1, [1, 3]);
volume = rotdim (volume, 1, [2, 3]);

[x,y,z] = size(volume);
arr = [];
for xx = [1:x]
  arr = [arr ismember(0,(unique(volume(xx,:,:)) == 0))];
end
volume = volume(logical(arr),:,:);
arr = [];
for yy = [1:y]
  arr = [arr ismember(0,(unique(volume(:,yy,:)) == 0))];
end
volume = volume(:,logical(arr),:);
arr = [];
for zz = [1:z]
  arr = [arr ismember(0,(unique(volume(:,:,zz)) == 0))];
end
volume = volume(:,:,logical(arr));
[x,y,z] = size(volume);

mcxplotvol(volume);

x_mm = unitinmm * x;
y_mm = unitinmm * y;
z_mm = unitinmm * z;

srcdir = [0 0 1];
srcdir = srcdir/norm(srcdir);
srcpos = [x_mm/2-2 y_mm/2 -5];
srcparam1 = [2];
srcdef=struct('srctype','disk',
              'srcpos',srcpos,
              'srcdir',srcdir,
              'srcparam1',srcparam1);  
              

detpos = [x_mm+1 0.5 0.5];
detdef =struct('srctype','planar',
            'srcpos',detpos,
            'srcdir',[1 0 0],
            'srcparam1',[0 0 z_mm],
            'srcparam2',[0 y_mm 0]);


[node, elem, detdef, srcdef] = create_mesh(volume, srcdef, detdef, unitinmm);
resZ = int16(z_mm*25);
resY = int16(y_mm*25);
im_total = zeros([resZ resY]);
plotopts.resolution = [resZ resY];
plotopts.filterV = kollimator;
for x = [1:sim_times]
  opts.isreflect = 1;
  [fluence, detphoton, cfg] = mmc_sim(node, elem, detdef, srcdef, opts);
  im = mmc_plot_by_detector(detphoton, detdef.srcdir, plotopts);
  im = flip(im);
  log_img = log(im);
  im_total = im_total + im;
end

% to simulate a second source:
% define the source 
% recreate the mesh
% run more simulations and add to the existing image
srcdir = [0 0 -1];
srcdir = srcdir/norm(srcdir);
srcpos = [x_mm/2-2 y_mm/2 5];
srcparam1 = [2];
srcdef=struct('srctype','disk',
              'srcpos',srcpos,
              'srcdir',srcdir,
              'srcparam1',srcparam1);
[node, elem, detdef, srcdef] = create_mesh(volume, srcdef, detdef, unitinmm);

for x = [1:sim_times]
  opts.isreflect = 1;
  [fluence, detphoton, cfg] = mmc_sim(node, elem, detdef, srcdef, opts);
  im = mmc_plot_by_detector(detphoton, detdef.srcdir, plotopts);
  im = flip(im);
  log_img = log(im);
  im_total = im_total + im;
end

  
create_png(im_total, strcat(filename, '-m-disk-diganocam99-res.png'))

tooth_figure = figure('name',strcat('mmcIMG tooth:', filename));
imagesc(log(im_total));
colorbar;
