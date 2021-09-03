
detectors = unique(detid);
n_det = size(detectors)(1);
p_by_det = cell(n_det,1);
v_by_det = cell(n_det,1);

for j=1:n_det
  p_by_det(j) = p(detectors(j) == detid,:);
  v_by_det(j) = v(detectors(j) == detid,:);
endfor

for i=1:n_det
  size(cell2mat(p_by_det(i)))
endfor

det1p = [cell2mat(p_by_det(1))' cell2mat(p_by_det(2))']';
det2p = [cell2mat(p_by_det(3))' cell2mat(p_by_det(4))']';

det1v = [cell2mat(v_by_det(1))' cell2mat(v_by_det(2))']';
det2v = [cell2mat(v_by_det(3))' cell2mat(v_by_det(4))']';



z = p(:,1);
z = z;
x = p(:,2);
y = p(:,3);

looparr = [0 100];

for i = looparr
  xy = [y z];
  
##  detv1_1 = det1v(:,1)' * (1 / det1v(:,3))';
##  detv1_2 = det1v(:,1)' * (1 / det1v(:,3))';
##  detv1_123 = [detv1_1' detv1_2' det1v(:,3)];

  p_minus_v = det1p-det1v*i;
  p_plus_v = det1p+det1v*i;

  p_minus_v = [p_minus_v(:,1) p_minus_v(:,2)];
  p_plus_v = [p_plus_v(:,1) p_plus_v(:,2)];

  binx = 128;
  biny = 128;

  [N,C] = hist3(p_plus_v, [binx,biny]);
  figure;
  imagesc(log(N));
endfor

for i = looparr
  xy = [y z];
  p_minus_v = det2p-det2v*i;
  p_plus_v = det2p+det2v*i;

  p_minus_v = [p_minus_v(:,2) p_minus_v(:,3)];
  p_plus_v = [p_plus_v(:,2) p_plus_v(:,3)];

  binx = 128;
  biny = 128;

  [N,C] = hist3(p_plus_v, [binx,biny]);
  figure;
  imagesc(log(N));
endfor