clear;
addpaths_turbo;

svmc = false;
opts.nphoton = 4e7;
opts.prop = prop_mcx_632nm();

filename = 'down256.mhd';

[volume, unitinmm] = load_data(filename);
volume(volume == 0) = 1;
[x,y,z] = size(volume);

% remove all layers around the tooth which are only background
arr = [];
for xx = [1:x]
  arr = [arr ismember(0,(unique(volume(xx,:,:)) == 1))];
end
volume = volume(logical(arr),:,:);
arr = [];
for yy = [1:y]
  arr = [arr ismember(0,(unique(volume(:,yy,:)) == 1))];
end
volume = volume(:,logical(arr),:);
arr = [];
for zz = [1:z]
  arr = [arr ismember(0,(unique(volume(:,:,zz)) == 1))];
end
volume = volume(:,:,logical(arr));
[x,y,z] = size(volume);

% add a padding 
% this is needed to place the detector
pad = 4;
v_one = ones(x+pad,y+pad,z+pad);
v_one(pad/2+1:x+pad/2, pad/2+1:y+pad/2, pad/2+1:z+pad/2) = volume;
volume = v_one;

% place the detector
volume(1:pad/2-1, :, :) = 0;

% prepare the volume for svmc if activated
if svmc
  volume = mcxsvmc_octave(volume);
  volume = cast(volume,'uint8');
end

% add a source and detector
srcdef.srctype = 'disk';
srcdef.srcpos = [x (y+pad)/2 (z+pad)/2];
srcdef.srcdir = [-1 0 0];
radius = sqrt(y*y+z*z)/2;
srcdef.srcparam1 = radius+2;

detpos = [pad/2 (y+pad)/2 (z+pad)/2 radius+2];

% start the sim
[detphoton,cfg] = mcx_sim(volume, unitinmm, srcdef, detpos, opts);

% generate the image
resY = int16(y*unitinmm*20);
resZ = int16(z*unitinmm*20);
plot_opts.resolution = [resY,resZ];
plot_opts.unitinmm = unitinmm;
im = mmc_plot_by_detector(detphoton, [1 0 0], plot_opts);
im = im(2:resY-1,2:resZ-1);

% save and display the image
create_png(im, 'mcx-tooth-final');

if DISPLAY_FIGURES
  tooth_figure = figure('name',strcat('mcx tooth', int2str(cfg.isreflect)));
  imagesc(log(im));
  colorbar;
end

