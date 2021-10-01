
function [detphoton, p, v, prop] = mcx_sim(volume,unitinmm)

  % use this line if you want to record the diffuse reflactance directly around the tooth
  %volume(volume == 1) = 0;

  % number of photons
  cfg.nphoton=4e7;
  cfg.maxdetphoton = cfg.nphoton / 4 * 3;
  % the previously loaded voxel-volume
  cfg.vol=volume;

  %cfg.vol(:,:,1)=0;   % pad a layer of 0s to get diffuse reflectance

  % properties of border(0) background(1), enamel(2), dentin(3), pulp(4)
  % [mua,mus,g,n] mua and mus in 1/mm

  % cfg.prop=[0 0 1 1;
  %           0 0 1 1;
  %           1 6 0.96 1.631;
  %           3.5 28 0.93 1.54;
  %           2.8 0 1 1.333]; %water?!

  cfg.prop=[0 0 1 1;
            0 0 1 1;
            0.1 2.867 0.99 1.63;
            0.35 22.193 0.83 1.49;          
            2.8 0 1 1.333]; %water?!

  % define the source
  cfg.issrcfrom0=1;
  cfg.srctype='disk';
  cfg.srcpos = [256 256/2 127*3/5+128];
  srcdir = [-1 0 0];
  srcdir = srcdir/norm(srcdir);
  cfg.srcdir=srcdir;
  cfg.srcparam1=80;
  cfg.srcparam2=[0 0 0 0];

  cfg.detpos = [65 256/2 256/2 182];

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

  % export the config to a json
  %  mcx2json(cfg,'mcx_cfg_octave');


  % calculate the fluence distribution with the given config
  
  [fluence,detphoton,vol,seeds,traj]=mcxlab(cfg);

  if(isfield(detphoton,'p'))
    p = detphoton.p;
  end
  if(isfield(detphoton,'v'))
    v = detphoton.v;
  end
  if(isfield(detphoton,'prop'))
    prop = detphoton.prop;
  end
  
end

