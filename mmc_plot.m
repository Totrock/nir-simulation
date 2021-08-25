%% plotting the result
%
% plot the cross-section of the fluence
% subplot(121);
% plotmesh([cfg.node(:,1:3),log10(abs(fluence.data(1:size(cfg.node,1))))],cfg.elem,'y=30','facecolor','interp','linestyle','none')
% view([0 1 0]);
% colorbar;

%% plot the surface diffuse reflectance

mesh_diffuse_reflectance_plotted = figure;

if(isfield(cfg,'issaveref') && cfg.issaveref==1)
    subplot(111);
    faces=faceneighbors(cfg.elem,'rowmajor');
    hs=plotmesh(cfg.node,faces,'cdata',log10(fluence.dref(:,1)),'linestyle','none');
    colorbar;
end

p(:,1) = 0.16;
p2 = p+v;
pall = [p p2];

plot3(p(:,1),p(:,2),p(:,3),'*');
hold on;
plot3(p2(:,1),p2(:,2),p2(:,3),'*');
hold off;

%plot3(p(:,1),p(:,2),p(:,3),p2(:,1),p2(:,2),p2(:,3));


xx=[p(:,1) p2(:,1)];
yy=[p(:,2) p2(:,2)];
zz=[p(:,3) p2(:,3)];
plot3(xx',yy',zz');

