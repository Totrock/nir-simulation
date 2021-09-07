addpath(genpath("./read3d/"))

% In Matlab one can use the GUI with:
%volume = ReadData3D("./down256.mhd",false);

volume = mha_read_volume("down256.mhd");
volume = cast(volume,'uint8');

[x,y,z] = size(volume);

% overwrite each 0 with a 1
volume(volume == 0) = 1;

% pad the volume with a layer of zeros
volume(1,:,:)=0;
volume(:,1,:)=0;
volume(:,:,1)=0;

volume(x,:,:)=0;
volume(:,y,:)=0;
volume(:,:,z)=0;

% the original µCT has 1024 voxel in x-axis where 1 voxel is 0.02 mm
% due to downsampling unitinmm is slightly wrong for the z-axis TODO?
unitinmm=(1024 / x) * 0.02;

x_mm = unitinmm * x;
y_mm = unitinmm * y;
z_mm = unitinmm * z;
