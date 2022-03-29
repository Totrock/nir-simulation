addpaths_turbo;

% just a very short demo code for
% how to iterate over all files in a directory

%tooth_dir = '/home/probst/data/praemolar/';
tooth_dir = '/home/probst/data/molar/';

files = dir(tooth_dir);
for file = files'
    if regexp(file.name, '.raw rotated_256*.mhd')
      filename = strcat(tooth_dir, file.name);
      filename
      [volume, unitinmm] = load_data(filename);
      %...
    end
end
  