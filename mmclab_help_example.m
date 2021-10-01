addpath(genpath("./read3d/"))

addpaths_turbo;

volume = mha_read_volume("block.mhd");
volume = cast(volume,'uint8');

[x,y,z] = size(volume);

unitinmm=(1024 / x) * 0.02;

x_mm = unitinmm * x;
y_mm = unitinmm * y;
z_mm = unitinmm * z;


volume_for_mesh = volume;

clear opt node face elem triangVolume;
triangVolume = 1000;

opt.distbound=1;    % set max distance that deviates from the level-set
opt.radbound=4;      % set surface triangle maximum size
opt.autoregion=0;     % don't save interior points
opt.A = diag([unitinmm,unitinmm,unitinmm]); % include voxel size in mm as scaling matrix
opt.B = zeros(3,1); % no translation

[node, elem, face] = v2m(volume_for_mesh, [], opt, triangVolume, 'cgalmesh');

tooth_det = figure;
plotmesh(node,elem);

node = node(:,1:3);



srcdir = [-1 0 0];
srcdir = srcdir/norm(srcdir);
srcpos = [x_mm y_mm/2 z_mm/2];
srcparam1 = [2 0 0];
srcdef=struct('srctype','disk',
                'srcpos',srcpos,
                'srcdir',srcdir,
                'srcparam1',srcparam1);            

[node,elem]=mmcaddsrc(node,elem,srcdef);

tooth_det = figure;
plotmesh(node,elem);

detsize = 8;
detpos2 = [x_mm/4-0.1  y_mm/2-detsize/2 z_mm/2-detsize/2];
detdef2 =struct('srctype','planar',
              'srcpos',detpos2,
              'srcdir',[0 0 0],
              'srcparam1',[0 detsize 0],
              'srcparam2',[0 0 detsize]);
  
[node,elem]=mmcadddet(node,elem,detdef2);

newelem = elem;
newnode = node;

tooth_det = figure;
plotmesh(newnode,newelem);

% the created mesh is now in mm
unitinmm = 1;

clear opt face ans srcdir tooth_det_src tooth_fig tooth_det triangVolume node elem node_w_det elem_w_det;




clear cfg srcdir fluence detphoton ncfg seeds mesh_diffuse_reflectance_plotted;


cfg.nphoton=1e8;

cfg.maxdetphoton = cfg.nphoton/10;

cfg.node = newnode;
cfg.elem = newelem;

cfg.srctype=srcdef.srctype;
cfg.srcpos=srcdef.srcpos;
cfg.srcdir=srcdef.srcdir;
cfg.srcparam1=srcdef.srcparam1;

cfg.detpos=[detpos2 1];

cfg.elemprop=cfg.elem(:,5);
cfg.elem=cfg.elem(:,1:4);

cfg.prop=[0 0 1 1;
          0.35 22.193 0.83 1.49;%dummy
          2.8 0 1 1.333;%0.1 2.867 0.99 1.63;
          0.35 22.193 0.83 1.49;          
          2.8 0 1 1.333]; %water?!
cfg.tstart=0;
cfg.tend=5e-9;
cfg.tstep=5e-9;

cfg.issaveexit=1;


[fluence,detphoton,ncfg,seeds]=mmclab(cfg);


if(isfield(detphoton,'detid'))
  detid = detphoton.detid;
end
if(isfield(detphoton,'nscat'))
  nscat = detphoton.nscat;
end
if(isfield(detphoton,'ppath'))
  ppath = detphoton.ppath;
end
if(isfield(detphoton,'p'))
  p = detphoton.p;
end
if(isfield(detphoton,'v'))
  v = detphoton.v;
end
if(isfield(detphoton,'w0'))
  w0 = detphoton.w0;
end
if(isfield(detphoton,'prop'))
  prop = detphoton.prop;
end
if(isfield(detphoton,'data'))
  data = detphoton.data;
end



% create a set of this array
detectors = unique(detid);
% number of detectors
n_det = size(detectors)(1);
% create "dynamic arrays" / cells  
p_by_det = cell(n_det,1);
photonweight_by_det = cell(n_det,1);

detw=mmcdetweight(detphoton,prop,1);

dett=mmcdettime(detphoton,prop,1);

for j=1:n_det
  p_by_det(j) = p(detectors(j) == detid,:);
  photonweight_by_det(j) = detw(detectors(j) == detid,:);
endfor


det2p = [cell2mat(p_by_det(1))' cell2mat(p_by_det(2))']';

photonweight_d2 = [cell2mat(photonweight_by_det(1))' cell2mat(photonweight_by_det(2))']';

binx = 64;
biny = 64;

% detector 2
det2p = [det2p(:,2) det2p(:,3)];

[r_edges, c_edges] = edges_from_nbins(det2p, [binx biny]);
r_idx = lookup (r_edges, det2p(:,1), "l");
c_idx = lookup (c_edges, det2p(:,2), "l");
im = zeros(binx, biny);
for j = 1:length(r_idx)
    im(c_idx(j), r_idx(j)) += photonweight_d2(j);
endfor


figure('name','Detector 2 - NIRT');
imagesc(log(im));
colorbar;


