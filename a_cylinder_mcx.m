clear;
addpaths_turbo;

load 'cylinder.mat'

[x,y,z] = size(volume);

volume(volume == 0) = 1;
volume(:, :, 60)=0;

cfg.nphoton=1e7;
cfg.maxdetphoton = cfg.nphoton;
cfg.vol=volume;

cfg.prop = [0 0 1 1;
           0 0 1 1;
           0.04 0.5 0.9 1.633;
           0.15 6.6 0.96 1.54]; 
cfg.issrcfrom0 = 1;
cfg.srctype ='disk';
cfg.srcpos = [x/2 y/2 z*0.8];
srcdir = [0 0 -1];
srcdir = srcdir/norm(srcdir);
cfg.srcdir = srcdir;
cfg.srcparam1 = 100;
cfg.srcparam2 = [0 0 0 0];

cfg.detpos = [x/2 y/2 60 150];

cfg.savedetflag = 'dspmxvw';        
cfg.issaveref = 1;
cfg.autopilot = 1;
cfg.tstart = 0;
cfg.tend = 5e-9;
cfg.tstep = 5e-9;

cfg.unitinmm = unitinmm;

figure();
mcxpreview(cfg);
title('domain preview');

for cfg.isreflect = [0:1] 

  [fluence,detphoton,vol,seeds,traj]=mcxlab(cfg);

  if(isfield(detphoton,'p'))
    p = detphoton.p;
  end
  if(isfield(detphoton,'v'))
    v = detphoton.v;
  end
  if(isfield(detphoton,'prop'))
    prop = detphoton.prop;
  end

  %% visualisation

  detw=mmcdetweight(detphoton,prop,unitinmm);

  image_pixel_x = 256;
  image_pixel_y = 256;

  % detector is in y-z-plane so ignore x
  p = [p(:,1) p(:,2)];
  % create a raster/grid
  [r_edges, c_edges] = edges_from_nbins(p, [image_pixel_x image_pixel_y]);
  % sort the photons into the raster/grid
  r_idx = lookup (r_edges, p(:,1), "l");
  c_idx = lookup (c_edges, p(:,2), "l");
  % create empty image
  im = zeros(image_pixel_x, image_pixel_y);
  % sum the calculated weights for each pixel
  for j = 1:length(r_idx)
      im(c_idx(j), r_idx(j)) += detw(j);
  endfor

  im2 = im(60:195,60:195);

  figure('name',strcat('MCX cylinder isreflect=',int2str(cfg.isreflect)));
  imagesc(log(im2));
  colorbar;
end