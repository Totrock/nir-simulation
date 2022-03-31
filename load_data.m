function [volume, unitinmm] = load_data(filename)

  % In Matlab one can use the GUI with:
  % volume = ReadData3D("./down256.mhd",false);

  volume = mha_read_volume(filename);
  volume = cast(volume,'uint8');

  % The images called 'down*.mhd' are coded the following way:
  % padding / outer-most-layer = 0
  % background = 1
  % enamel = 2
  % dentin = 3
  % pulp = 4
  
  % The images in /home/probst/data/(prae)molar/ are coded the following way:
  % background = 0
  % enamel = 1
  % dentin = 2
  % pulp = 3
  
  % mcx needs 1 as background
  % when creating a mesh for mmc the background of the volume which gets 
  % converted to a should have 0 as background
  
  % preprocessing steps are done accordingly in the scripts
  

  % the original µCT has 1024 voxel in x-axis where 1 voxel is 0.02 mm
  % due to downsampling unitinmm is slightly wrong for the z-axis TODO?
  [x,y,z] = size(volume);
  unitinmm = (1024 / x) * 0.02;

end
