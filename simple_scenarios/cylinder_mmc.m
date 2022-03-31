addpaths_turbo;

[volume, unitinmm] = load_data('cylinder.mhd');
volume = rotdim (volume, 1, [1, 3]);

[x,y,z] = size(volume);
x_mm = unitinmm * x;
y_mm = unitinmm * y;
z_mm = unitinmm * z;
srcdir = [0 0 -1];
srcdir = srcdir/norm(srcdir);
srcpos = [x_mm/2+0.5 y_mm/2+0.5 z_mm-3];
srcparam1 = [8.5 0 0];
srcdef=struct('srctype','disk',...
              'srcpos',srcpos,...
              'srcdir',srcdir,...
              'srcparam1',srcparam1);  
detsize = 11;
detpos = [x_mm/2-detsize/2+0.5 y_mm/2-detsize/2+0.5 2];
detdef =struct('srctype','planar',...
              'srcpos',detpos,...
              'srcdir',[0 0 1],...
              'srcparam1',[detsize 0 0],...
              'srcparam2',[0 detsize 0]);

%% create mesh
volume(volume == 0) = 1;
volume = volume - 1;
opt.distbound=1;    % set max distance that deviates from the level-set
opt.radbound=4;      % set surface triangle maximum size
opt.autoregion=0;     % don't save interior points
opt.A = diag([unitinmm,unitinmm,unitinmm]); % include voxel size in mm as scaling matrix
opt.B = zeros(3,1); % no translation
[node, elem, face] = v2m(volume, 1:max(volume(:)), opt, 1000, 'cgalmesh');
tooth = figure('name','cylinder');
plotmesh(node, elem);
colorbar;
colormap ('prism');

node = node(:,1:3);
[node,elem]=mmcaddsrc(node,elem,srcdef);
tooth_src = figure;
plotmesh(node, elem);
colorbar;
[node,elem]=mmcadddet(node,elem,detdef);
tooth_det = figure;
plotmesh(node, elem);
colorbar;


%% create cfg for simulation  
cfg.nphoton = 1e7;
cfg.prop = [0 0 1 1;           % air
           0.04 0.5 0.9 1.633; % outer cylinder - enamel
           0.15 6.6 0.96 1.54] % inner cylinder - dentin   
cfg.maxdetphoton = cfg.nphoton;
cfg.node = node;
cfg.elem = elem;
cfg.srctype=srcdef.srctype;
cfg.srcpos=srcdef.srcpos;
cfg.srcdir=srcdef.srcdir;
cfg.srcparam1=srcdef.srcparam1;
cfg.detpos=[detdef.srcpos 1];
cfg.elemprop=cfg.elem(:,5);


cfg.elem=cfg.elem(:,1:4);
cfg.tstart=0;
cfg.tend=5e-9;
cfg.tstep=5e-9;
cfg.detpos = [detdef.srcpos 0];
cfg.detparam1 = [detsize 0 0];
cfg.detparam2 = [0 detsize 0];
cfg.issaveexit = 1; 
cfg.issaveref = 1; 
        
for isreflect = [0:1] 
    cfg.isreflect = isreflect;
    [fluence, detphoton, cfg] = mmclab(cfg);
    im = mmc_plot_by_detector(detphoton, detdef.srcdir) ;
    tooth_figure = figure('name',strcat('MMC cylinder reflect:', int2str(cfg.isreflect)));
    imagesc(log(im));
    create_png(im, strcat('cylinder-mmc-1e8-250-reflect', int2str(isreflect)))
    colorbar;
end