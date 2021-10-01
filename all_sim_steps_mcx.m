clear;
addpaths_turbo;

filename = 'down256.mhd';
do_padding = true;

detector_opposite_side = true;

[volume, unitinmm, x_mm, y_mm, z_mm] = load_data(filename, do_padding);

volume(volume == 0) = 1;
v_one = ones(256,256,256);
v_one(:,:,(256-128):256) = volume;
volume = v_one;
detsize = 60;
volume(65, :, :)=0;
volume = cast(volume,'uint8');

[detphoton, p, v, prop] = mcx_sim(volume,unitinmm);

im = (detphoton, p, v, prop, detector_opposite_side);

create_png(im, 'mcx');