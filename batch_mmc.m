clear;
addpaths_turbo;

molar_dir = '/home/probst/data/praemolar/';
files = dir(molar_dir);
for file = files'
    if regexp(file.name, '5768.raw rotated_256*.mhd') %|| regexp(file.name, '5769.raw rotated_256*.mhd')|| regexp(file.name, '5776.raw rotated_256*.mhd')|| regexp(file.name, '5784.raw rotated_256*.mhd')
      filename = strcat(molar_dir, file.name);
      
      [volume, unitinmm] = load_data(filename);
      volume = rotdim (volume, 1, [1, 3]);
      [x,y,z] = size(volume);

      volume = volume + 1;
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
      figure();
      mcxplotvol (volume)
      [x,y,z] = size(volume);

      x_mm = unitinmm * x;
      y_mm = unitinmm * y;
      z_mm = unitinmm * z;

      srcdir = [0 0 1];
      srcdir = srcdir/norm(srcdir);
      srcpos = [x_mm/2 y_mm/2 -5];
      srcparam1 = [6];
      srcdef=struct('srctype','disk',
                    'srcpos',srcpos,
                    'srcdir',srcdir,
                    'srcparam1',srcparam1);  

      detsize = max(x_mm, y_mm);
      detpos = [0.5 0.5 z_mm+0.5];
      detdef =struct('srctype','planar',
                  'srcpos',detpos,
                  'srcdir',[0 0 -1],
                  'srcparam1',[detsize 0 0],
                  'srcparam2',[0 detsize 0]);
      
      
        [node, elem, detdef, srcdef] = create_mesh(volume, srcdef, detdef, unitinmm);
        if DISPLAY_FIGURES > 1
          figure();
          plotmesh(node, elem(elem(:,5)~=0,:));
          colorbar;
        endif
        

        opts.nphoton = 1e8;
        opts.issaveexit = 2;
        img = zeros([250,250]);
        for i = [5*pi/180 10*pi/180 15*pi/180 20*pi/180]
          srcdef.srcparam1 = i;
          [fluence, detphoton, cfg] = mmc_sim(node, elem, detdef, srcdef, opts);
%          im = sum(detphoton.data,3)';
          im = mmc_plot_by_detector(detphoton, detdef.srcdir);
          im = rotdim(im,3);
          img = img + im;
          
        endfor
        
        im = img;

        create_png(im, strcat(file.name, '.png'));
        if DISPLAY_FIGURES
          tooth_figure = figure('name',strcat('mmc tooth reflect:', file.name));
          imagesc(log(im));
          colorbar;
        end
      end


end