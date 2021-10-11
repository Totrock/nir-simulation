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
srcpos = [x_mm-3 y_mm/2 z_mm*3/5];
srcparam1 = [6 0 0];
srcdef=struct('srctype','disk',
              'srcpos',srcpos,
              'srcdir',srcdir,
              'srcparam1',srcparam1);  

detsize = 13;
detpos = [5 y_mm/2-detsize/2 z_mm/2-detsize/2];
detdef =struct('srctype','planar',
              'srcpos',detpos,
              'srcdir',[1 0 0],
              'srcparam1',[0 detsize 0],
              'srcparam2',[0 0 detsize]);
              
[node, elem, detdef, srcdef] = create_mesh(volume, srcdef, detdef, unitinmm);

opts.nphoton = 1e7;
               
[fluence, detphoton, cfg] = mmc_sim(node, elem, detdef, srcdef, opts);

im = mmc_plot_by_detector(detphoton, detdef.srcdir);

create_png(im, 'mmc');

if DISPLAY_FIGURES
  tooth_figure = figure('name','mmc tooth');
  imagesc(log(im));
  colorbar;
end
