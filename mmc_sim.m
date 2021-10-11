function [fluence, detphoton, cfg] = mmc_sim(node, elem, detdef, srcdef, opts)

  if(isstruct(opts))
    if (~isfield(opts,'nphoton'))
      opts.nphoton = 1e7;
    end
    if (~isfield(opts,'maxdetphoton'))
      opts.maxdetphoton = opts.nphoton / 5;
    end
    if (~isfield(opts,'prop'))
      opts.prop = default_mmc_prop_kienle();
    end
  end
  
  % configure the GPU ID!
  %cfg.gpuid=1;

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
  % node has to have 3 cols, the 4th col of node contains similar information as elem-col-5
  % used this as reference: https://github.com/fangq/mmc/blob/master/examples/skinvessel/createsession.m
  cfg.elemprop=cfg.elem(:,5);
  cfg.elem=cfg.elem(:,1:4);
  %cfg.node=cfg.node(:,1:3);

  cfg.prop= opts.prop;

            
             
  cfg.tstart=0;
  cfg.tend=5e-9;
  cfg.tstep=5e-9;
  ##cfg.debuglevel='TP';
  cfg.issaveref=1;  % in addition to volumetric fluence, also save surface diffuse reflectance
  cfg.issaveexit=1;
  
  cfg.outputtype = 'fluence';
  
  cfg.isreflect=0;
%  cfg.method='elem';

  %use this for pencil source
  %  cfg.e0 = '-';


  %% Use this line to create a json config and many binary files to use mmc directly
  %mmc2json(cfg, 'mmc_cfg_octave')

  %% run the simulation
  [fluence,detphoton,ncfg,seeds]=mmclab(cfg);

  %% save simulation to file
  ##save detected_photons.mat detphoton;
  ##save cfg.mat cfg;

end
