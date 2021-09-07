% create a set of this array
detectors = unique(detid);
% number of detectors
n_det = size(detectors)(1);
% create "dynamic arrays" / cells  
p_by_det = cell(n_det,1);
v_by_det = cell(n_det,1);
photonweight_by_det = cell(n_det,1);

##tpsf_by_det = cell(n_det,1);
##for j=1:n_det
##  tpsf_by_det(j) = mmcdettpsf(detphoton,detectors(j),prop,[cfg.tstart cfg.tend cfg.tstep]);
##endfor

detw=mmcdetweight(detphoton,prop,1);

dett=mmcdettime(detphoton,prop,1);

% the array detid is a list of detectors
% I saves for each detected photon by which detector it was detected.
for j=1:n_det
  p_by_det(j) = p(detectors(j) == detid,:);
  v_by_det(j) = v(detectors(j) == detid,:);
  photonweight_by_det(j) = detw(detectors(j) == detid,:);
endfor

% this is hardcoded for now 
% the detector 1 consists of triangles 1 and 2 and det2 of 3 and 4 
det1p = [cell2mat(p_by_det(1))' cell2mat(p_by_det(2))']';
det2p = [cell2mat(p_by_det(3))' cell2mat(p_by_det(4))']';

det1v = [cell2mat(v_by_det(1))' cell2mat(v_by_det(2))']';
det2v = [cell2mat(v_by_det(3))' cell2mat(v_by_det(4))']';

photonweight_d1 = [cell2mat(photonweight_by_det(1))' cell2mat(photonweight_by_det(2))']';
photonweight_d2 = [cell2mat(photonweight_by_det(3))' cell2mat(photonweight_by_det(4))']';

binx = 100;
biny = 100;

% detector 1
det1p = [det1p(:,1) det1p(:,2)];

[r_edges, c_edges] = edges_from_nbins(det1p, [binx biny]);
r_idx = lookup (r_edges, det1p(:,1), "l");
c_idx = lookup (c_edges, det1p(:,2), "l");
im = zeros(binx, biny);
for j = 1:length(r_idx)
    im(c_idx(j), r_idx(j)) += photonweight_d1(j);
endfor

figure;
imagesc(log(im));
colorbar;


% detector 2
det2p = [det2p(:,2) det2p(:,3)];

[r_edges, c_edges] = edges_from_nbins(det2p, [binx biny]);
r_idx = lookup (r_edges, det2p(:,1), "l");
c_idx = lookup (c_edges, det2p(:,2), "l");
im = zeros(binx, biny);
for j = 1:length(r_idx)
    im(c_idx(j), r_idx(j)) += photonweight_d2(j);
endfor


figure;
imagesc(log(im));
colorbar;


