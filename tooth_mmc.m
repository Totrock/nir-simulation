clear;
cfg.gpuid = 1;
%% prepare the volume
load 'data-mcx.mat';
volume(volume == 0) = 1;
volume = volume - 1;

volume = rotdim (volume, 1, [1, 3]);

%% setup and run mesh generation
opt.distbound=1;
opt.radbound=4;
opt.autoregion=0;
opt.A = diag([unitinmm,unitinmm,unitinmm]);
opt.B = zeros(3,1);
[node, elem, face] = v2m(volume, 1:max(volume(:)), opt, 100, 'cgalmesh');

node = node(:,1:3);

%% add source and detector
%tooth = figure('name','Tooth');
%plotmesh(node, elem);
%colorbar;

[x,y,z] = size(volume);
x_mm = unitinmm * x;
y_mm = unitinmm * y;
z_mm = unitinmm * z;

srcdir = [0 0 -1];
srcdir = srcdir/norm(srcdir);
% x is close to the tooth and y/z are approx. the center of the tooth
srcpos = [x_mm*2.5/10 y_mm/2 z_mm+1];
srcparam1 = [6 0 0];
srcdef=struct('srctype','disk',
              'srcpos',srcpos,
              'srcdir',srcdir,
              'srcparam1',srcparam1);  
              
[node,elem]=mmcaddsrc(node,elem,srcdef);

%tooth_src = figure('name','Tooth with source');
%plotmesh(node, elem);
%colorbar;
  
detsize = 12;
detpos = [(x_mm*2.5/10)-detsize/2 y_mm/2-detsize/2 0];
detdef =struct('srctype','planar',
              'srcpos',detpos,
              'srcdir',[1 0 0],
              'srcparam1',[detsize 0 0 40],
              'srcparam2',[0 detsize 0 40]);
              
[node,elem]=mmcadddet(node,elem,detdef);

%tooth_det = figure('name','Tooth with source and detector');
%plotmesh(node, elem);
%colorbar;


%% setup and run simulation
cfg.nphoton=1e7;
cfg.maxdetphoton = cfg.nphoton;

cfg.node = node;
cfg.elem = elem;

cfg.srctype=srcdef.srctype;
cfg.srcpos=srcdef.srcpos;
cfg.srcdir=srcdef.srcdir;
cfg.srcparam1=srcdef.srcparam1;

cfg.elemprop=cfg.elem(:,5);
cfg.elem=cfg.elem(:,1:4);

cfg.prop = [0 0 1 1.633;
            0.04 0.5 0.9 1.633;
            0.15 6.6 0.96 1.54;    
            2.8 2.75 0.77 1.39]; 

cfg.tstart=0;
cfg.tend=5e-9;
cfg.tstep=5e-9;

cfg.isreflect=0;

cfg.issaveexit = 2;

cfg.detpos = [detpos 0];
cfg.detparam1 = [detsize 0 0 128];
cfg.detparam2 = [0 detsize 0 128];

cfg.debuglevel = 'TP';
%cfg.seed = 12345678;

[flux,detphoton]=mmclab(cfg);

if cfg.issaveexit == 2
  figure('name','ise=2, MMC tooth isreflect=0');
  imagesc(log(sum(detphoton.data,3)'));
  colorbar;
else
  
  if(isfield(detphoton,'p'))
    p = detphoton.p;
  end
  if(isfield(detphoton,'prop'))
    prop = detphoton.prop;
  end

  %% visualisation
  detw=mmcdetweight(detphoton,prop,1);

  image_pixel_x = 128;
  image_pixel_y = 128;

  % detector is in y-z-plane so ignore x
  p = [p(:,1) p(:,2)];
  % create a raster/grid
  [r_edges, c_edges] = edges_from_nbins(p, [image_pixel_x image_pixel_y]);
  % sort the photons into the raster/grid
  r_idx = lookup (r_edges, p(:,1), "l");
  c_idx = lookup (c_edges, p(:,2), "l");
  % create empty image
  im = zeros(image_pixel_y, image_pixel_x);
  % sum the calculated weights for each pixel
  for j = 1:length(r_idx)
      im(c_idx(j), r_idx(j)) += detw(j);
  endfor

  figure('name','ise=1, MMC tooth isreflect=0');
  imagesc(log(im));
  colorbar;
end


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
cfg.gpuid = 1;
%% prepare the volume
load 'data-mcx.mat';
volume(volume == 0) = 1;
volume = volume - 1;

volume = rotdim (volume, 1, [1, 3]);

%% setup and run mesh generation
opt.distbound=1;
opt.radbound=4;
opt.autoregion=0;
opt.A = diag([unitinmm,unitinmm,unitinmm]);
opt.B = zeros(3,1);
[node, elem, face] = v2m(volume, 1:max(volume(:)), opt, 100, 'cgalmesh');

node = node(:,1:3);

%% add source and detector
%tooth = figure('name','Tooth');
%plotmesh(node, elem);
%colorbar;

[x,y,z] = size(volume);
x_mm = unitinmm * x;
y_mm = unitinmm * y;
z_mm = unitinmm * z;

srcdir = [0 0 -1];
srcdir = srcdir/norm(srcdir);
% x is close to the tooth and y/z are approx. the center of the tooth
srcpos = [x_mm*2.5/10 y_mm/2 z_mm+1];
srcparam1 = [6 0 0];
srcdef=struct('srctype','disk',
              'srcpos',srcpos,
              'srcdir',srcdir,
              'srcparam1',srcparam1);  
              
[node,elem]=mmcaddsrc(node,elem,srcdef);

%tooth_src = figure('name','Tooth with source');
%plotmesh(node, elem);
%colorbar;
  
detsize = 12;
detpos = [(x_mm*2.5/10)-detsize/2 y_mm/2-detsize/2 0];
detdef =struct('srctype','planar',
              'srcpos',detpos,
              'srcdir',[1 0 0],
              'srcparam1',[detsize 0 0 40],
              'srcparam2',[0 detsize 0 40]);
              
[node,elem]=mmcadddet(node,elem,detdef);

%tooth_det = figure('name','Tooth with source and detector');
%plotmesh(node, elem);
%colorbar;


%% setup and run simulation
cfg.nphoton=1e7;
cfg.maxdetphoton = cfg.nphoton;

cfg.node = node;
cfg.elem = elem;

cfg.srctype=srcdef.srctype;
cfg.srcpos=srcdef.srcpos;
cfg.srcdir=srcdef.srcdir;
cfg.srcparam1=srcdef.srcparam1;

cfg.elemprop=cfg.elem(:,5);
cfg.elem=cfg.elem(:,1:4);

cfg.prop = [0 0 1 1;
            0.04 0.5 0.9 1.633;
            0.15 6.6 0.96 1.54;    
            2.8 2.75 0.77 1.39]; 

cfg.tstart=0;
cfg.tend=5e-9;
cfg.tstep=5e-9;

cfg.isreflect=1;

cfg.issaveexit = 2;

cfg.detpos = [detpos 0];
cfg.detparam1 = [detsize 0 0 128];
cfg.detparam2 = [0 detsize 0 128];

cfg.debuglevel = 'TP';
%cfg.seed = 12345678;

[flux,detphoton]=mmclab(cfg);

if cfg.issaveexit == 2
  figure('name','ise=2, MMC tooth isreflect=1');
  imagesc(log(sum(detphoton.data,3)'));
  colorbar;
else
  
  if(isfield(detphoton,'p'))
    p = detphoton.p;
  end
  if(isfield(detphoton,'prop'))
    prop = detphoton.prop;
  end

  %% visualisation
  detw=mmcdetweight(detphoton,prop,1);

  image_pixel_x = 128;
  image_pixel_y = 128;

  % detector is in y-z-plane so ignore x
  p = [p(:,1) p(:,2)];
  % create a raster/grid
  [r_edges, c_edges] = edges_from_nbins(p, [image_pixel_x image_pixel_y]);
  % sort the photons into the raster/grid
  r_idx = lookup (r_edges, p(:,1), "l");
  c_idx = lookup (c_edges, p(:,2), "l");
  % create empty image
  im = zeros(image_pixel_y, image_pixel_x);
  % sum the calculated weights for each pixel
  for j = 1:length(r_idx)
      im(c_idx(j), r_idx(j)) += detw(j);
  endfor

  figure('name','ise=1, MMC tooth isreflect=0');
  imagesc(log(im));
  colorbar;
end
