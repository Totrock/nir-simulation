addpaths_turbo;
%
% a basic simulation with mmc
% source and detector are on opposing sides
%
filename = '/home/probst/data/molar/Z_209_C0005777.raw rotated_256.mhd';
nphoton = 1e7;
sim_times = 2;
img_filename = '5777mmc180';
opts.prop = prop_mmc_780nm();
% radius of src in mm
% e.g. switch between 1 and 8
radius = 8

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

figure();
mcxplotvol(volume);
[x,y,z] = size(volume);

x_mm = unitinmm * x;
y_mm = unitinmm * y;
z_mm = unitinmm * z;

srcdir = [-1 0 0];
srcdir = srcdir/norm(srcdir);
srcpos = [x_mm+2 y_mm/2+0.5 z_mm/4*3+0.5];
srcparam1 = [radius 0 0];
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

opts.nphoton = nphoton;
 
p1 = int16(sum(detdef.srcparam1)*20);
p2 = int16(sum(detdef.srcparam2)*20);
img = zeros([p1 p2]);
plot_opt.resolution = [p1, p2];
plot_opt.filterV =0;  

for i = [1:sim_times]
  [flux, detphoton, cfg] = mmc_sim(node, elem, detdef, srcdef, opts);
  im = mmc_plot_by_detector(detphoton, detdef.srcdir, plot_opt);
%  im = rotdim(im,3);
  img = img + im;    
end



  
im = im(2:p1-1, 2:p2-1);
create_png(im, img_filename);
if DISPLAY_FIGURES
  tooth_figure = figure('name',strcat('mmc tooth reflect:', int2str(cfg.isreflect)));
  imagesc(log(im));
  colorbar;
end

% show slices of the flux
figure;
qmeshcut(cfg.elem(cfg.elemprop>0,1:4),cfg.node*unitinmm,log(flux.data),'x=0.5','linestyle','none');
figure;
qmeshcut(cfg.elem(cfg.elemprop>0,1:4),cfg.node*unitinmm,log(flux.data),'y=0.5','linestyle','none');
figure;
qmeshcut(cfg.elem(cfg.elemprop>0,1:4),cfg.node*unitinmm,log(flux.data),'z=0.5','linestyle','none');

