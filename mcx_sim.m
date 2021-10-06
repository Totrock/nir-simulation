function detphoton = mcx_sim(volume, unitinmm, srcdef, detpos, opts)
  %todo check nargin
  if(isstruct(opts))
    if (~isfield(opts,'nphoton'))
      opts.nphoton = 4e7;
    end
    if (~isfield(opts,'maxdetphoton'))
      opts.maxdetphoton = opts.nphoton /2;
    end
    if (~isfield(opts,'prop'))
      % with caries unique in vol --> 5 or 6
      opts.prop = default_mcx_prop_kienle();
    end
  end

  % use this line if you want to record the diffuse reflactance directly around the tooth
  %volume(volume == 1) = 0;

  % number of photons
  cfg.nphoton=opts.nphoton;
  cfg.maxdetphoton = opts.maxdetphoton;
  

  %cfg.vol(:,:,1)=0;   % pad a layer of 0s to get diffuse reflectance

  % properties of border(0) background(1), enamel(2), dentin(3), pulp(4)
  % [mua,mus,g,n] mua and mus in 1/mm

  % cfg.prop=[0 0 1 1;
  %           0 0 1 1;
  %           1 6 0.96 1.631;
  %           3.5 28 0.93 1.54;
  %           2.8 0 1 1.333]; %water?!

  cfg.prop = opts.prop;

  % define the source
  cfg.issrcfrom0=1;
  
##  cfg.srctype='disk';
##  cfg.srcpos = [256 256/2 128];
##  %cfg.srcpos = [256 256/2 127*3/5+128];
##  srcdir = [-1 0 0];
##  srcdir = srcdir/norm(srcdir);
##  cfg.srcdir=srcdir;
##  cfg.srcparam1=200;
##  cfg.srcparam2=[0 0 0 0];

  cfg.srctype = srcdef.srctype;
  cfg.srcpos = srcdef.srcpos;
  cfg.srcdir = srcdef.srcdir;
  cfg.srcparam1 = srcdef.srcparam1;
  cfg.srcparam2=[0 0 0 0];

  cfg.detpos = detpos;
  cfg.savedetflag='dspmxvw';
  % cfg.bc='______110110';  % capture photons existing from all faces
        
  cfg.issaveref=1;

  cfg.gpuid=1;
  cfg.autopilot=1;
  cfg.tstart=0;
  cfg.tend=5e-9;
  cfg.tstep=5e-9;

  % original is 0.02 mm resolution with 1024*1024*517 
  cfg.unitinmm = unitinmm;
  
  % the previously loaded voxel-volume
  cfg.vol=volume;

  % export the config to a json
  %  mcx2json(cfg,'mcx_cfg_octave');
  
  global DISPLAY_FIGURES;
  if DISPLAY_FIGURES
    figure();
    mcxpreview(cfg);
  end


  % calculate the fluence distribution with the given config
  
  [fluence,detphoton,vol,seeds,traj]=mcxlab(cfg);  
end

