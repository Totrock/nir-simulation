function [detphoton, ppath, p, v, detid, prop] = mmc_sim(node, elem, detdef, srcdef, detector_opposite_side)

  clear cfg srcdir fluence detphoton ncfg seeds;

  % configure the GPU ID!
  %cfg.gpuid=1;

  cfg.nphoton=1e8;
  % could be set lower in many scenarios
  % depends on number, dimensions and positioning of detectors 
    if detector_opposite_side
      cfg.maxdetphoton = cfg.nphoton/10;
    else
      cfg.maxdetphoton = cfg.nphoton;
    endif

  cfg.node = node;
  cfg.elem = elem;

  % copy the source-definition from create_mesh.m
  cfg.srctype=srcdef.srctype;
  cfg.srcpos=srcdef.srcpos;
  cfg.srcdir=srcdef.srcdir;
  cfg.srcparam1=srcdef.srcparam1;

  cfg.detpos=[detdef.srcpos 1];

  % the 5th col of elem contains information about which region the tetrahedron is assigned to 
  % this has to be copied to elemprop
  % elem has to have 4 cols 
  % node has to have 3 cols, the 4th col of node contains similar information as elem-col-5
  % used this as reference: https://github.com/fangq/mmc/blob/master/examples/skinvessel/createsession.m
  cfg.elemprop=cfg.elem(:,5);
  cfg.elem=cfg.elem(:,1:4);
  %cfg.node=cfg.node(:,1:3);

  cfg.prop=[0 0 1 1;
            0.1 2.867 0.99 1.63;
            0.35 22.193 0.83 1.49;          
            2.8 0 1 1.333]; %water?!
            
             
  cfg.tstart=0;
  cfg.tend=5e-9;
  cfg.tstep=5e-9;
  ##cfg.debuglevel='TP';
  ##cfg.issaveref=1;  % in addition to volumetric fluence, also save surface diffuse reflectance
  cfg.issaveexit=1;

  %use this for pencil source
  %  cfg.e0 = '-';


  %% Use this line to create a json config and many binary files to use mmc directly
  %mmc2json(cfg, 'mmc_cfg_octave')

  %% run the simulation
  [fluence,detphoton,ncfg,seeds]=mmclab(cfg);

  %% save simulation to file
  ##save detected_photons.mat detphoton;
  ##save cfg.mat cfg;

  %% extract detphoton
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

end
