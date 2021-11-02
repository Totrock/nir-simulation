clear;
load 'data-mcx.mat';
[x,y,z] = size(volume);
cfg.gpuid = -1;


cfg.nphoton=1e7;
cfg.maxdetphoton = cfg.nphoton;
cfg.vol=volume;

cfg.prop = [0 0 1 1;
           0 0 1 1;
           0.04 0.5 0.9 1.633;
           0.15 6.6 0.96 1.54;  
           2.8 2.75 0.77 1.39]; 
cfg.issrcfrom0 = 1;
cfg.srctype ='disk';
% y/z coordinates are approx. the center of the tooth
cfg.srcpos = [x y/2 z*0.8];
srcdir = [-1 0 0];
srcdir = srcdir/norm(srcdir);
cfg.srcdir = srcdir;
cfg.srcparam1 = 80;
cfg.srcparam2 = [0 0 0 0];

cfg.detpos = [65 y/2 z/2 182];

cfg.savedetflag = 'dspmxvw';        
cfg.issaveref = 1;
cfg.autopilot = 1;
cfg.tstart = 0;
cfg.tend = 5e-9;
cfg.tstep = 5e-9;

cfg.isreflect = 0;

cfg.unitinmm = unitinmm;

figure();
mcxpreview(cfg);
title('domain preview');

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
p = [p(:,2) p(:,3)];
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

im2 = im(130:255,60:190);

figure('name','MCX tooth isreflect=0');
imagesc(log(im2));
colorbar;

%%% 
%%% 
%%% 
%%% 
%%%
%%% NOW the exactly same, but isreflect = 1
%%%
%%% 
%%% 
%%% 
%%% 

clear;
cfg.gpuid = -1;

load 'data-mcx.mat';
[x,y,z] = size(volume);

cfg.nphoton=1e7;
cfg.maxdetphoton = cfg.nphoton;
cfg.vol=volume;

cfg.prop = [0 0 1 1;
           0 0 1 1;
           0.04 0.5 0.9 1.633;
           0.15 6.6 0.96 1.54;  
           2.8 2.75 0.77 1.39]; 
cfg.issrcfrom0 = 1;
cfg.srctype ='disk';
% y/z coordinates are approx. the center of the tooth
cfg.srcpos = [x y/2 z*0.8];
srcdir = [-1 0 0];
srcdir = srcdir/norm(srcdir);
cfg.srcdir = srcdir;
cfg.srcparam1 = 80;
cfg.srcparam2 = [0 0 0 0];

cfg.detpos = [65 y/2 z/2 182];

cfg.savedetflag = 'dspmxvw';        
cfg.issaveref = 1;
cfg.autopilot = 1;
cfg.tstart = 0;
cfg.tend = 5e-9;
cfg.tstep = 5e-9;

cfg.isreflect = 1;

cfg.unitinmm = unitinmm;

figure();
mcxpreview(cfg);
title('domain preview');

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
p = [p(:,2) p(:,3)];
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

im2 = im(130:255,60:190);

figure('name','MCX tooth isreflect=1');
imagesc(log(im2));
colorbar;