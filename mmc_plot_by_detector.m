function im = mmc_plot_by_detector(detphoton, p, v, prop, detector_opposite_side)

  detw=mmcdetweight(detphoton,prop,1);

  binx = 128;
  biny = 128;
  % create empty image
  im = zeros(binx, biny);

  if detector_opposite_side
    % detector 2
    p = [p(:,2) p(:,3)];

    [r_edges, c_edges] = edges_from_nbins(p, [binx biny]);
    r_idx = lookup (r_edges, p(:,1), "l");
    c_idx = lookup (c_edges, p(:,2), "l");
    for j = 1:length(r_idx)
        im(c_idx(j), r_idx(j)) += detw(j);
    endfor


    tooth_figure = figure('name','Detector 2 - NIRT');
    imagesc(log(im));
    colorbar;
  else
    % detector 1
    % detector 1 is in the xy-plane z is irrelevant
    gegenkat = sqrt(v(:,1) .* v(:,1)+v(:,2) .* v(:,2));
    alpha = atan(gegenkat ./ det1v(:,3));
    cosalpha = cos(alpha);
    p = [p(:,1) p(:,2)];

    % create a raster/grid
    [r_edges, c_edges] = edges_from_nbins(det1p, [binx biny]);
    % sort the photons into the raster/grid
    r_idx = lookup (r_edges, p(:,1), "l");
    c_idx = lookup (c_edges, p(:,2), "l");
    % sum the calculated weights for each pixel
    for j = 1:length(r_idx)
        im(c_idx(j), r_idx(j)) +=  detw(j);% .* cosalpha(j);
    endfor

##    tooth_figure = figure('name','Detector 1 - occlusal');
##    imagesc(log(im));
##    colorbar;
  endif
end