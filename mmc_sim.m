function [flux, detphoton, cfg] = mmc_sim(node, elem, detdef, srcdef, opts)
% this script wraps mmclab
% it will simply set a few default values 
% and extract necessary data from the given parameters


  % load defaults if needed
  if(isstruct(opts))
    if (~isfield(opts,'nphoton'))
      opts.nphoton = 1e7;
    end
    if (~isfield(opts,'maxdetphoton'))
      opts.maxdetphoton = opts.nphoton;
    end
    if (~isfield(opts,'prop'))
      opts.prop = prop_mcx_780nm();
    end
    if (~isfield(opts,'isreflect'))
      opts.isreflect = 1;
    end
    if (~isfield(opts,'issaveexit'))
      opts.issaveexit = 1;
    end
  end
  
  % configure the GPU ID!
  % one could use this ratio, but the speedup is not really worth it
%  cfg.gpuid='11';
%  cfg.workload = [14,1];

  cfg.nphoton=opts.nphoton;
  % could be set lower in many scenarios
  % depends on number, dimensions and positioning of detectors 
  cfg.maxdetphoton = opts.maxdetphoton;
  
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
  % node has to have 3 cols (this is already done in create_mesh.m)
  cfg.elemprop=cfg.elem(:,5);
  cfg.elem=cfg.elem(:,1:4);

  cfg.prop= opts.prop;

  cfg.tstart=0;
  cfg.tend=1e-5;
  cfg.tstep=1e-5;
  cfg.issaveref=1;  % save surface diffuse reflectance
  cfg.issaveexit = opts.issaveexit; % save photons which hit a detector (detphoton)
  
  % this will activate the widefield detector of mmc
  % I did not implement dynamically sized detectors for this
  % the resolution of the image will be 400 by 400 
  if cfg.issaveexit == 2
    cfg.detpos = [detdef.srcpos 0];
    cfg.detparam1 = [sum(detdef.srcparam1) 0 0 400];
    cfg.detparam2 = [0 sum(detdef.srcparam1) 0 400];
  end
  
  % cfg.outputtype = 'fluence';
  
  cfg.isreflect = opts.isreflect;
  cfg.method='elem';

  % the pencil source needs this
  % cfg.e0 = '-';

  % Use this line to create a json config and many binary files to use mmc directly
  % mmc2json(cfg, 'mmc_cfg_octave')
  

  % run the simulation
  [flux,detphoton] = mmclab(cfg);

  % activate the following lines to save simulation result/configuration to a file:
  % save detected_photons.mat detphoton;
  % save cfg.mat cfg;

end
