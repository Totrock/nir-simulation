addpaths_turbo;
tic;
filename = '/home/probst/data/molar/Z_209_C0005777.raw rotated_256.mhd';
opts.nphoton = 4e7;
img_filename = 'prop_mmc_780nm_1e8';
opts.prop = prop_mmc_780nm();

% load the tooth
[volume, unitinmm] = load_data(filename);
[x,y,z] = size(volume);
volume = volume + 1;
% remove all layers around the tooth which are only background
arr = [];
for xx = [1:x]
  arr = [arr ismember(0,(unique(volume(xx,:,:)) == 1))];
end
volume = volume(logical(arr),:,:);
arr = [];
for yy = [1:y]
  arr = [arr ismember(0,(unique(volume(:,yy,:)) == 1))];
end
volume = volume(:,logical(arr),:);
arr = [];
for zz = [1:z]
  arr = [arr ismember(0,(unique(volume(:,:,zz)) == 1))];
end
volume = volume(:,:,logical(arr));

[x,y,z] = size(volume);

x_mm = unitinmm * x;
y_mm = unitinmm * y;
z_mm = unitinmm * z;

srcdir = [-1 0 0];
srcdir = srcdir/norm(srcdir);
srcpos = [x_mm+2 y_mm/2+0.5 z_mm/2+0.5];
srcparam1 = [7.5 0 0];
srcdef=struct('srctype','disk',
              'srcpos',srcpos,
              'srcdir',srcdir,
              'srcparam1',srcparam1);  

detpos = [-1 0 0];
detdef =struct('srctype','planar',
              'srcpos',detpos,
              'srcdir',[1 0 0],
              'srcparam1',[0 y_mm+1 0],
              'srcparam2',[0 0 z_mm+1]);
      
[node, elem, detdef, srcdef] = create_mesh(volume, srcdef, detdef, unitinmm);


 
[fluence, detphoton, cfg] = mmc_sim(node, elem, detdef, srcdef, opts);

for d = [detdef]
  p1 = int16(sum(d.srcparam1)*25);
  p2 = int16(sum(d.srcparam2)*25);
  plot_opt.resolution = [p1, p2];
  im = mmc_plot_by_detector(detphoton, d.srcdir, plot_opt);
  im = im(1:p1-1, 1:p2-p2*0.05);
  create_png(im, img_filename);

  if DISPLAY_FIGURES
    tooth_figure = figure('name',strcat('mmc tooth reflect:', int2str(cfg.isreflect)));
    imagesc(log(im));
    colorbar;
  end
end
toc