clear;
addpaths_turbo;

filename = 'down256.mhd';

[volume, unitinmm] = load_data(filename);

volume(volume == 0) = 1;

v_one = ones(256,256,256);
v_one(:,:,(256-128):256) = volume;
volume = v_one;
volume(1:65, :, :)=0;


%load 'data.mat';
volume(1:65, :, :)=0;
mcxplotvol (volume);

% generate the volume for the split voxel simulation
[volume]=mcxsvmc(volume);

volume = cast(volume,'uint8');


srcdef.srctype = 'disk';
srcdef.srcpos = [256 128 256*0.8];
srcdef.srcdir = [-1 0 0];
srcdef.srcparam1 = [80 0 0 0];

%detpos = [65 128 127*3/5 100];
detpos = [65 128 128 182];


opts.nphoton = 1e7;
opts.maxdetphoton = opts.nphoton - opts.nphoton*37/100;

[detphoton,cfg] = mcx_sim(volume, unitinmm, srcdef, detpos, opts);

plot_opts.resolution = [200,200];
plot_opts.unitinmm = unitinmm;

im = mmc_plot_by_detector(detphoton, [1 0 0], plot_opts);
im2 = im(14:199,28:160);

create_png(im2, 'mcx');

if DISPLAY_FIGURES
  tooth_figure = figure('name',strcat('mcx tooth', int2str(opts.isreflect)));
  imagesc(log(im2));
  colorbar;
end

