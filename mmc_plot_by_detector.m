function im = mmc_plot_by_detector(detphoton, detdir, opts)
% this script will generate an image from the detected photons


  % a block to fill in default values
  % 'nargin' = number of arguments passed to the script
  if nargin == 2
    opts.resolution = [250, 250];
    opts.unitinmm = 1;
    opts.filterV = 0;
  endif
  if nargin > 2
    if (~isfield(opts,'resolution'))
      opts.resolution = [250, 250];
    end
    if (~isfield(opts,'unitinmm'))
      opts.unitinmm = 1;
    end
    if (~isfield(opts,'filterV'))
      opts.filterV = 0;
    end
  end
  biny = opts.resolution(1);
  binx = opts.resolution(2);

  % extract detphoton
  if(isfield(detphoton,'p'))
    p = detphoton.p;
  end
  if(isfield(detphoton,'v'))
    v = detphoton.v;
  end
  if(isfield(detphoton,'prop'))
    prop = detphoton.prop;
  end

  % calculate the weight of each photon
  detw=mmcdetweight(detphoton, prop, opts.unitinmm);
  
  % find out in which plane the detector is
  % and reduce the information about where the photon hit the detector
  % from 3D to 2D i.e. (xyz to xy/yz/xz)
  if detdir(1) == 1  
    p = [p(:,2) p(:,3)];
    v_dir = 1;
  elseif detdir(2) == 1
    p = [p(:,1) p(:,3)];
    v_dir = 2;
  else
    p = [p(:,1) p(:,2)];
    v_dir = 3;
  end

  %%%%%%%%%%%%%%%%%%%%
  % ignore all photons that hit the detector in a 90° angle
  %%%%%%%%%%%%%%%%%%%%
  if opts.filterV
    v_idx1 = abs(v(:,v_dir)) != 1;
    v = v(v_idx1,:);
    p = p(v_idx1,:);
    detw = detw(v_idx1,:);
  end
  %%%%%%%%%%%%%%%%%%%%
  % kind of a Collimator
  % filters out all photons which do not hit the detector almost orthogonally
  %%%%%%%%%%%%%%%%%%%%
  if opts.filterV
    v_idx2 = abs(v(:,v_dir)) > 0.99;
    v = v(v_idx2,:);
    p = p(v_idx2,:);
    detw = detw(v_idx2,:);
  end
  
  % create empty image
  im = zeros(biny, binx);
  % sort the photons into a grid and add the weights to each bin
  [r_edges, c_edges] = edges_from_nbins(p, [binx biny]);
  r_idx = lookup (r_edges, p(:,1), "l");
  c_idx = lookup (c_edges, p(:,2), "l");
  for j = 1:length(r_idx)
      im(c_idx(j), r_idx(j)) += detw(j);
  endfor

% hist3 needs the statistics package and can't account for the weight (but is much faster)
% im = hist3(p, 'Nbins', [biny binx]);
end