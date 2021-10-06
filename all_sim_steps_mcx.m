clear;
addpaths_turbo;

filename = 'down256.mhd';

[volume, unitinmm] = load_data(filename);

volume(volume == 0) = 1;
##v_one = ones(256,256,256);
##v_one(:,:,(256-128):256) = volume;
##volume = v_one;
volume(65, :, :)=0;
volume = cast(volume,'uint8');



srcdef.srctype = 'disk';
srcdef.srcpos = [256 128 127*3/5];
srcdef.srcdir = [-1 0 0];
srcdef.srcparam1 = [80 0 0 0];

detpos = [65 128 127*3/5 100];


opts.nphoton = 8e7;
opts.maxdetphoton = opts.nphoton /2;

img = 0;

for _ = [1:1]
  detphoton = mcx_sim(volume, unitinmm, srcdef, detpos, opts);

  plot_opts.resolution = [200,200];

  im = mmc_plot_by_detector(detphoton, [1 0 0], plot_opts);
  img = img + im;
end
im2 = img(14:200,28:160);

create_png(im2, 'mcx');

tooth_figure = figure('name','mcx tooth');
imagesc(log(im2));
colorbar;
