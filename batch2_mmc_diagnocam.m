addpaths_turbo;

%tooth_dir = '/home/probst/data/molar/';
tooth_dir = '/home/probst/data/praemolar/';
files = dir(tooth_dir);
sim_times = 5;
for file = files'
    if regexp(file.name, '5806.raw rotated_256*.mhd') % 5769.raw rotated_256*.mhd')5767
      filename = strcat(tooth_dir, file.name);
      
      [volume, unitinmm] = load_data(filename);
      volume = rotdim (volume, 1, [1, 3]);
      volume = rotdim (volume, 1, [2, 3]);

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
      [x,y,z] = size(volume);

      x_mm = unitinmm * x;
      y_mm = unitinmm * y;
      z_mm = unitinmm * z;

     srcdir = [0 0 1];
      srcdir = srcdir/norm(srcdir);
      srcpos = [x_mm/2-2 y_mm/2 -5];
      srcparam1 = [10*pi/180];
      srcdef=struct('srctype','cone',
                    'srcpos',srcpos,
                    'srcdir',srcdir,
                    'srcparam1',srcparam1);  
                    

      detpos = [x_mm+1 0.5 0.5];
      detdef =struct('srctype','planar',
                  'srcpos',detpos,
                  'srcdir',[1 0 0],
                  'srcparam1',[0 0 z_mm],
                  'srcparam2',[0 y_mm 0]);
      
      
        [node, elem, detdef, srcdef] = create_mesh(volume, srcdef, detdef, unitinmm);
        resZ = int16(z_mm*25);
        resY = int16(y_mm*25);
        im_total = zeros([resZ resY]);
        for x = [5*pi/180 10*pi/180 15*pi/180 20*pi/180]
          srcdef.srcparam1 = x;
          opts.nphoton = 1e8;
          opts.isreflect = 1;
          [fluence, detphoton, cfg] = mmc_sim(node, elem, detdef, srcdef, opts);
          plotopts.resolution = [resZ resY];
          plotopts.filterV = 1;
          im = mmc_plot_by_detector(detphoton, detdef.srcdir, plotopts);
          im = flip(im);
          log_img = log(im);
          if DISPLAY_FIGURES
            tooth_figure = figure('name',strcat('111mmc tooth reflect:', file.name));
            imagesc(log_img);
            colorbar;
          end
          im_total = im_total + im;
        end
      
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      %
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tooth_mesh_figure = figure('name',strcat('',file.name));
        colormap ('rainbow');
        plotmesh(node, elem(elem(:,5)~=0,:));
         tooth_mesh_figure = figure('name',strcat('',file.name));
                 colormap ('rainbow');
        plotmesh(node, elem(elem(:,5)>0,:));
      
      
        volume = rotdim (volume, 2, [2, 3]);
        [node, elem, detdef, srcdef] = create_mesh(volume, srcdef, detdef, unitinmm);

        
        
        tooth_mesh_figure = figure('name',strcat('',file.name));
        colormap ('rainbow');
        plotmesh(node, elem(elem(:,5)~=0,:));
         tooth_mesh_figure = figure('name',strcat('',file.name));
                 colormap ('rainbow');
        plotmesh(node, elem(elem(:,5)>0,:));

        opts.nphoton = 1e8;
        opts.isreflect = 1;
        for x = [5*pi/180 10*pi/180 15*pi/180 20*pi/180]
          srcdef.srcparam1 = x;
          [fluence, detphoton, cfg] = mmc_sim(node, elem, detdef, srcdef, opts);
          im2 = mmc_plot_by_detector(detphoton, detdef.srcdir, plotopts) ;
          im2 = rotdim(im2,3);
          im2 = rotdim(im2,3);
          im2 = flip(im2);
          img = im + im2;
          log_img = log(im2);
            if DISPLAY_FIGURES
              tooth_figure = figure('name',strcat('222mmc tooth reflect:', file.name));
              imagesc(log_img);
              colorbar;
            end
          im_total = im_total + im2;
        end
        
        create_png(im_total, strcat(file.name, '-m-diganocam99-res.png'))
      
      tooth_figure = figure('name',strcat('333mmcIMG tooth reflect:', file.name));
          imagesc(log(im_total));
          colorbar;
        colorbar;

  end

end