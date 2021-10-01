clear;
addpaths_turbo;

filename = 'down256.mhd';
do_padding = false;

src_radius = 6;
yshift = 0;
zshift = 0;

[volume, unitinmm, x_mm, y_mm, z_mm] = load_data(filename, do_padding);


detector_opposite_side = true;

srcdir = [-1 0 0];
srcdir = srcdir/norm(srcdir);
srcpos = [x_mm-3 y_mm/2+yshift z_mm*3/5+zshift];
srcparam1 = [src_radius 0 0];
srcdef=struct('srctype','disk',
              'srcpos',srcpos,
              'srcdir',srcdir,
              'srcparam1',srcparam1);  
              
[node, elem, unitinmm, detdef, srcdef] = create_mesh(volume, detector_opposite_side, unitinmm, x_mm, y_mm, z_mm, srcdef);

[detphoton, ppath, p, v, detid, prop] = mmc_sim(node, elem, detdef, srcdef, detector_opposite_side);

im = mmc_plot_by_detector(detphoton, p, v, prop, detector_opposite_side);

create_png(im, 'mmc');


