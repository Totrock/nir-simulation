function [volume, unitinmm] = load_data(filename)

  % In Matlab one can use the GUI with:
  %volume = ReadData3D("./down256.mhd",false);

  volume = mha_read_volume(filename);
  volume = cast(volume,'uint8');

  [x,y,z] = size(volume);
  
  % The loaded images are /(should be) coded in the following way:
  % padding / outer-most-layer = 0 TODO dont do this in preprocessing
  % background = 1
  % enamel = 2
  % dentin = 3
  % pulp = 4
  
##  if do_padding
##    % overwrite each 0 with a 1
##    volume(volume == 0) = 1;
##
##    % pad the volume with a layer of zeros
##    volume(1,:,:)=0;
##    volume(:,1,:)=0;
##    volume(:,:,1)=0;
##
##    volume(x,:,:)=0;
##    volume(:,y,:)=0;
##    volume(:,:,z)=0;
##  endif

  % the original µCT has 1024 voxel in x-axis where 1 voxel is 0.02 mm
  % due to downsampling unitinmm is slightly wrong for the z-axis TODO?
  unitinmm = (1024 / x) * 0.02;

end
