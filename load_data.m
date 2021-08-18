addpath(genpath("./read3d/"))

% we cant use this because of Octave
%volume = ReadData3D("./down256.mhd",false);

volume = mha_read_volume("down64.mhd");
volume = cast(volume,'uint8');

[x,y,z] = size(volume);

volume(volume == 0) = 1;

volume(:,:,1)=0;
volume(:,1,:)=0;
volume(1,:,:)=0;

volume(:,:,z)=0;
volume(:,y,:)=0;
volume(x,:,:)=0;

v1 = x;
v_mid = v1 / 2;
v_mid_plus = v_mid  + 10;
v_mid_minus = v_mid  - 10;




