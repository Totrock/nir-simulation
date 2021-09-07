% integrate time-axis (4th dimension) to get CW solutions
cwfluence=sum(fluence.data,4);  % fluence rate
cwdref=sum(fluence.dref,4);     % diffuse reflectance

f0 = figure;

% plot configuration and results
% subplot(231);

%mcxpreview(cfg);title('domain preview');

% f1 = figure;
% 
% z34 = (z+1)*3/4;
% 
% subplot(121);
% title1 = strcat('fluence at x=',int2str(v_mid));
% imagesc(squeeze(log(cwfluence(v_mid,:,:))));title(title1);
% 
% subplot(122);
% title1 = strcat('fluence at y=',int2str(v_mid));
% imagesc(squeeze(log(cwfluence(:,v_mid,:))));title(title1);

mcxplotvol(log(cwfluence(:,:,:)));

% Some error with ppath
% subplot(236);
% hist(detpt.ppath(:,1),50); title('partial path tissue#1');

% subplot(233);
% title1 = strcat('TPSF at [', int2str(v_mid),']');
% plot(squeeze(fluence.data(v_mid,v_mid,v_mid,:)),'-o');title(title1);

%TOO many
%newtraj=mcxplotphotons(traj);title('photon trajectories')
%subplot(236);

%imagesc(squeeze(log(cwdref(:,:,1))));title('diffuse refle. at z=1');



% z_dist = cwdref(:,:,1);
% subplot(235);
% image(z_dist);title('no log');

% subplot(236);

% plot3(detpt.p(:,1),detpt.p(:,2),detpt.p(:,3),'r.');


f2 = figure;

[x,y,z] = size(volume);

subplot(231);
title1 = strcat('diffuse refle. at  x=1');
imagesc(squeeze(log(cwdref(1,:,:))));title(title1);

subplot(232);
title1 = strcat('diffuse refle. at  y=1');
imagesc(squeeze(log(cwdref(:,1,:))));title(title1);

subplot(233);
title1 = strcat('diffuse refle. at  z=1');
imagesc(squeeze(log(cwdref(:,:,1))));title(title1);

subplot(234);
title1 = strcat('diffuse refle. at  x');
imagesc(squeeze(log(cwdref(x,:,:))));title(title1);

subplot(235);
title1 = strcat('diffuse refle. at  y');
imagesc(squeeze(log(cwdref(:,y,:))));title(title1);

subplot(236);
title1 = strcat('diffuse refle. at  z');
imagesc(squeeze(log(cwdref(:,:,z))));title(title1);


mcxplotvol(log(cwdref(:,:,:)));

% f3 = figure;

% isosurface(log(cwdref(:,:,:)),log(cwdref(:,:,:))); 
%volumeViewer(cwdref(:,:,:));


clear title1 z_dist
