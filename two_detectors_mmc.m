addpaths_turbo;

filename = './data/down256.mhd';
opts.nphoton = 1e6;

[volume, unitinmm] = load_data(filename);
[x,y,z] = size(volume);

volume(volume == 0) = 1;
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
srcpos = [x_mm+1 y_mm/2 z_mm/2];
srcparam1 = [5 0 0];
srcdef=struct('srctype','disk',
              'srcpos',srcpos,
              'srcdir',srcdir,
              'srcparam1',srcparam1);  

detsize = max(z_mm, y_mm);
detpos = [-1 y_mm/2-detsize/2 z_mm/2-detsize/2];
detdef =struct('srctype','planar',
              'srcpos',detpos,
              'srcdir',[1 0 0],
              'srcparam1',[0 detsize 0],
              'srcparam2',[0 0 detsize]);
% mit  +1 broken
detsize2 = max(x_mm, y_mm);
detpos2 = [x_mm/2-detsize2/2 y_mm/2-detsize2/2 -1];
detdef2 =struct('srctype','planar',
            'srcpos',detpos2,
            'srcdir',[0 0 1],
            'srcparam1',[detsize2 0 0],
            'srcparam2',[0 detsize2 0]);

%detsize = 9;
%detpos = [x_mm y_mm/2-detsize/2 z_mm*0.7-detsize/2];
%detdef =struct('srctype','planar',
%            'srcpos',detpos,
%            'srcdir',[1 0 0],
%            'srcparam1',[0 detsize 0],
%            'srcparam2',[0 0 detsize]);
              
[node, elem, detdef2, srcdef] = create_mesh(volume, srcdef, detdef2, unitinmm, detdef);

figure();
plotmesh(node, elem(elem(:,5)~=0,:));

 
opts.isreflect = 1
[fluence, detphoton, cfg] = mmc_sim(node, elem, detdef, srcdef, opts, detdef2);

for d = [detdef detdef2]
  plot_opt.resolution = [200, 200];
  im = mmc_plot_by_detector(detphoton, d.srcdir, plot_opt);

  im2 = im(int16(plot_opt.resolution(1)*0.195):int16(plot_opt.resolution(1)*0.94),int16(plot_opt.resolution(2)*0.11):int16(plot_opt.resolution(2)*0.89));

  create_png(im2, 'mmc');

  if DISPLAY_FIGURES
    tooth_figure = figure('name',strcat('mmc tooth reflect:', int2str(cfg.isreflect)));
    imagesc(log(im(2:199,2:199)));
    colorbar;
  end
end