addpaths_turbo;

svmc = 1;
cfg.nphoton=1e7;

[volume, unitinmm] = load_data('./data/cylinder.mhd'); % cylinder_in_cube.mhd or cylinder.mhd

cfg.prop = prop_mcx_700nm_kienle();

volume = rotdim (volume, 1, [1, 3]);

[x,y,z] = size(volume);

volume(volume == 0) = 1;
volume(:, :, 1:60) = 0;

if svmc
  [volume]=mcxsvmc_octave(volume);
  volume = cast(volume,'uint8');
end

cfg.maxdetphoton = cfg.nphoton;
cfg.vol=volume;
 
cfg.issrcfrom0 = 0;
cfg.srctype ='disk';
cfg.srcpos = [x/2 y/2 z*0.8];
srcdir = [0 0 -1];
srcdir = srcdir/norm(srcdir);
cfg.srcdir = srcdir;
cfg.srcparam1 = 100;
cfg.srcparam2 = [0 0 0 0];

cfg.detpos = [x/2 y/2 60 120];

cfg.issaveexit = 1;
cfg.autopilot = 1;
cfg.tstart = 0;
cfg.tend = 1;
cfg.tstep = 1;

cfg.unitinmm = unitinmm;

for cfg.isreflect = [0:1] 

  [fluence,detphoton,vol,seeds,traj]=mcxlab(cfg);
  
  image_pixel_x = 400;
  image_pixel_y = 400;
  plot_opts.resolution = [image_pixel_y,image_pixel_x];
  plot_opts.unitinmm = cfg.unitinmm;

  im = mmc_plot_by_detector(detphoton, [0 0 1], plot_opts);

  im2 = im(int16(image_pixel_x*0.22):int16(image_pixel_x*0.78),int16(image_pixel_x*0.22):int16(image_pixel_x*0.78));

  figure('name',strcat('MCX cylinder isreflect=',int2str(cfg.isreflect)));
  imagesc(log(im2));
  create_png(im2, strcat('cylinder-mcx-svmc=',int2str(svmc),'-',int2str(cfg.nphoton),'reflect', int2str(cfg.isreflect)))

  colorbar;
end