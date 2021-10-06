clear;
addpaths_turbo;

filename = 'block.mhd';
for opts.nphoton = [1e6,1e7,1e8]

  [volume, unitinmm] = load_data(filename);

  volume = volume + 1;

  srcdef = default_block_mmc_srcdef;
  detdef = default_block_mmc_detdef;
                
  [node, elem, detdef, srcdef] = create_mesh(volume, srcdef, detdef, unitinmm);

  opts.prop = [0 0 1 1;
               0.1 2.867 0.99 1.63;
               0.1 2.867 0.99 1.63;
               0.35 22.193 0.83 1.49;        
               2.8 0 1 1.333]; %water?!

  detphoton = mmc_sim(node, elem, detdef, srcdef, opts);

  im = mmc_plot_by_detector(detphoton, detdef.srcdir);

  im = im(20:118,20:118);

  tooth_figure = figure('name',strcat('mmc block ', int2str(opts.nphoton)));  imagesc(log(im));
  colorbar;

  create_png(im, 'mmc');

end
