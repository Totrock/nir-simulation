function im = mmc_plot_by_detector(detphoton, detdir, opts)
  
  if nargin == 2
    binx = 128;
    biny = 128;
  else
    binx = opts.resolution(1);
    biny = opts.resolution(2);
  end
  
  %% extract detphoton
##  if(isfield(detphoton,'detid'))
##    detid = detphoton.detid;
##  end
##  if(isfield(detphoton,'nscat'))
##    nscat = detphoton.nscat;
##  end
##  if(isfield(detphoton,'ppath'))
##    ppath = detphoton.ppath;
##  end
  if(isfield(detphoton,'p'))
    p = detphoton.p;
  end
  if(isfield(detphoton,'v'))
    v = detphoton.v;
  end
##  if(isfield(detphoton,'w0'))
##    w0 = detphoton.w0;
##  end
##  if(isfield(detphoton,'prop'))
##    prop = detphoton.prop;
##  end
##  if(isfield(detphoton,'data'))
##    data = detphoton.data;
##  end

  detw=mmcdetweight(detphoton,detphoton.prop,1);

  
  % create empty image
  im = zeros(binx, biny);

  if detdir(1) == 1  
    p = [p(:,2) p(:,3)];
  elseif detdir(2) == 1
    p = [p(:,1) p(:,3)];
  else
    p = [p(:,1) p(:,2)];
  end
  

  [r_edges, c_edges] = edges_from_nbins(p, [binx biny]);
  r_idx = lookup (r_edges, p(:,1), "l");
  c_idx = lookup (c_edges, p(:,2), "l");
  for j = 1:length(r_idx)
      im(c_idx(j), r_idx(j)) += detw(j);
  endfor


##  tooth_figure = figure('name','Detector 2 - NIRT');
##  imagesc(log(im));
##  colorbar;


##    % detector 1
##    % detector 1 is in the xy-plane z is irrelevant
##    gegenkat = sqrt(v(:,1) .* v(:,1)+v(:,2) .* v(:,2));
##    alpha = atan(gegenkat ./ det1v(:,3));
##    cosalpha = cos(alpha);
##    p = [p(:,1) p(:,2)];
##
##    % create a raster/grid
##    [r_edges, c_edges] = edges_from_nbins(det1p, [binx biny]);
##    % sort the photons into the raster/grid
##    r_idx = lookup (r_edges, p(:,1), "l");
##    c_idx = lookup (c_edges, p(:,2), "l");
##    % sum the calculated weights for each pixel
##    for j = 1:length(r_idx)
##        im(c_idx(j), r_idx(j)) +=  detw(j);% .* cosalpha(j);
##    endfor
end