addpaths_turbo
% add needed paths
config = 1;% 1 or 2 --- 1 does work 2 not

[cfg.node,face,cfg.elem]=meshabox([3 3 3],[27 27 27],10,10);
cfg.prop=[0 0 1 1;0.005 5.1 0.999 1.2];
cfg.nphoton=10000;
cfg.tstart=0;
cfg.tend=1e-8;
cfg.tstep=1e-9;
cfg.issaveexit = 2;

if config == 1
  cfg.srcpos=[15,15,0];
  cfg.srcdir=[0 0 1];
end
if config == 2
  cfg.srcpos=[0,15,15];
  cfg.srcdir=[1 0 0];
end
srcdir = cfg.srcdir;
srcpos = cfg.srcpos;
srcparam1 = [0.20 0];
srcdef=struct('srctype','cone',
              'srcpos',srcpos,
              'srcdir',srcdir,
              'srcparam1',srcparam1); 
             
if config == 1
detdef =struct('srctype','planar',
              'srcpos',[0 0 30],
              'srcdir',[0 0 0],
              'srcparam1',[30 0 0],
              'srcparam2',[0 30 0]);   
end
if config == 2   
detdef =struct('srctype','planar',
              'srcpos',[30 0 0],
              'srcdir',[0 0 0],
              'srcparam1',[0 30 0],
              'srcparam2',[0 0 30]);
end

cfg.detpos = [detdef.srcpos 0];
if config == 1 
cfg.detparam1 = [30.0 0 0 100];
cfg.detparam2 = [0 30.0 0 100];
end
if config == 2
cfg.detparam1 = [0 30.0 0 100];
cfg.detparam2 = [0 0 30.0 100];
end

cfg.elem=[cfg.elem ones(size(cfg.elem,1),1)];

[cfg.node,cfg.elem]=mmcaddsrc(cfg.node,cfg.elem,srcdef);
[cfg.node,cfg.elem]=mmcadddet(cfg.node,cfg.elem,detdef);

cfg.elemprop=cfg.elem(:,5);

figure;
plotmesh(cfg.node, cfg.elem);

[flux,detphoton,ncfg,seeds]=mmclab(cfg);

figure;
imagesc(sum(detphoton.data,3)');
axis equal;