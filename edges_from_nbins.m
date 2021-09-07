% copied from hist3
function [r_edges, c_edges] = edges_from_nbins (X, nbins)
  if (! isnumeric (nbins) || numel (nbins) != 2)
    error ("hist3: NBINS must be a 2 element vector");
  endif
  inits = min (X, [], 1);
  ends  = max (X, [], 1);
  ends -= (ends - inits) ./ vec (nbins, 2);

  ## If any histogram side has an empty range, then still make NBINS
  ## but then place that value at the centre of the centre bin so that
  ## they appear in the centre in the plot.
  single_bins = inits == ends;
  if (any (single_bins))
    inits(single_bins) -= (floor (nbins(single_bins) ./2)) + 0.5;
    ends(single_bins) = inits(single_bins) + nbins(single_bins) -1;
  endif

  r_edges = linspace (inits(1), ends(1), nbins(1));
  c_edges = linspace (inits(2), ends(2), nbins(2));
endfunction