function [detphoton,cfg] = mcx_sim(volume, unitinmm, srcdef, detpos, opts)
  %todo check nargin
  if(isstruct(opts))
    if (~isfield(opts,'nphoton'))
      opts.nphoton = 1e7;
    end
    if (~isfield(opts,'maxdetphoton'))
      opts.maxdetphoton = opts.nphoton;
    end
    if (~isfield(opts,'maxjumpdebug'))
      opts.maxjumpdebug = opts.nphoton *35;
    end
    if (~isfield(opts,'prop'))
      % with caries unique in vol --> 5 or 6
      opts.prop = default_mcx_prop_kienle();
    end
    if (~isfield(opts,'isreflect'))
      opts.isreflect = 1;
    end
  end

  % number of photons
  cfg.nphoton = opts.nphoton;
  cfg.maxdetphoton = opts.maxdetphoton;
  cfg.maxjumpdebug = opts.maxjumpdebug;


  % properties of border/detector(0), background(1), enamel(2), dentin(3), pulp(4)
  % [mua,mus,g,n] mua and mus in 1/mm
  cfg.prop = opts.prop;

  % define the source
  cfg.issrcfrom0 = 1;

  cfg.srctype = srcdef.srctype;
  cfg.srcpos = srcdef.srcpos;
  cfg.srcdir = srcdef.srcdir;
  cfg.srcparam1 = srcdef.srcparam1;
  %cfg.srcparam2 = [0 0 0 0];

  cfg.detpos = detpos;
  
  % what data about the detected photons should be saved:
  
  %    1 D output detector ID (1)
  %    2 S output partial scat. even counts (#media)
  %    4 P output partial path-lengths (#media)
  %    8 M output momentum transfer (#media)
  %    16 X output exit position (3)
  %    32 V output exit direction (3)
  %    64 W output initial weight (1) 
  
  cfg.savedetflag='pxv';
    
  % set to 1 if diffuse reflectance should be saved
  cfg.issaveref = 0;

  cfg.gpuid = 1;
  cfg.autopilot = 1;
  % a very high tend in order to not terminate the photons too early
  cfg.tstart = 0;
  cfg.tend = 1e-5;
  cfg.tstep = 1e-5;

  % original is 0.02 mm resolution with 1024*1024*517 
  cfg.unitinmm = unitinmm;
  
  % the previously loaded voxel-volume
  cfg.vol=volume;
  
  cfg.isreflect=opts.isreflect;

  % export the config to a json
  % mcx2json(cfg,'mcx_cfg_octave');
  
  % display a preview of the simulation setup
  global DISPLAY_FIGURES;
  if DISPLAY_FIGURES > 1 & length(size(cfg.vol)) == 3
    figure();
    mcxpreview(cfg);
  end


  % calculate the fluence, diffuse reflectance and photons at the detecor(s) with the given config
  [fluence,detphoton]=mcxlab(cfg); 
end

