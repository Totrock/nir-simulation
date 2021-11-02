clear;
addpaths_turbo;

filename = 'down256.mhd';

[volume, unitinmm] = load_data(filename);
[x,y,z] = size(volume);
x_mm = unitinmm * x;
y_mm = unitinmm * y;
z_mm = unitinmm * z;

srcdir = [-1 0 0];
srcdir = srcdir/norm(srcdir);
srcpos = [x_mm-1 y_mm/2 z_mm*0.7];
srcparam1 = [5.5 0 0];
srcdef=struct('srctype','disk',
              'srcpos',srcpos,
              'srcdir',srcdir,
              'srcparam1',srcparam1);  

detsize = 9;
detpos = [5 y_mm/2-detsize/2 z_mm*0.6-detsize/2];
detdef =struct('srctype','planar',
              'srcpos',detpos,
              'srcdir',[1 0 0],
              'srcparam1',[0 detsize 0],
              'srcparam2',[0 0 detsize]);
              
detsize2 = 9+7/10;
detpos2 = [x_mm*0.6-detsize2/2 y_mm/2-detsize2/2 -7];
detdef2 =struct('srctype','planar',
            'srcpos',detpos2,
            'srcdir',[0 0 1],
            'srcparam1',[detsize2 0 0],
            'srcparam2',[0 detsize2 0]);
              
[node, elem, detdef, srcdef] = create_mesh(volume, srcdef, detdef, unitinmm, detdef2);

figure();
plotmesh(node, elem(elem(:,5)~=0,:));

opts.nphoton = 1e6;
 
opts.isreflect = 1
[fluence, detphoton, cfg] = mmc_sim(node, elem, detdef2, srcdef, opts);

plot_opt.resolution = [200, 200];
im = mmc_plot_by_detector(detphoton, detdef2.srcdir, plot_opt);

im2 = im(int16(plot_opt.resolution(1)*0.195):int16(plot_opt.resolution(1)*0.94),int16(plot_opt.resolution(2)*0.11):int16(plot_opt.resolution(2)*0.89));

create_png(im2, 'mmc');

if DISPLAY_FIGURES
  tooth_figure = figure('name',strcat('mmc tooth reflect:', int2str(cfg.isreflect)));
  imagesc(log(im(2:199,2:199)));
  colorbar;
end
