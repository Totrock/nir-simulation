clear;
addpaths_turbo;

for mcx_input.nphoton = [1e6,1e7,1e8]

  filename = 'block.mhd';

  [volume, unitinmm] = load_data(filename);
  volume = volume + 1;
  volume(volume == 1) = 0;
  volume(62:64, :, :)=1;

  
  mcx_input.prop = [0 0 1 1;
                    0 0 1 1;
                    0.1 2.867 0.99 1.63;
                    0.1 2.867 0.99 1.63;
                    0.35 22.193 0.83 1.49;          
                    2.8 0 1 1.333]; %water?!

  detphoton = mcx_sim(volume, unitinmm, default_block_mcx_srcdef, default_block_mcx_detpos, mcx_input);

  
  im = mmc_plot_by_detector(detphoton, [1 0 0]);

  im = im(20:105,20:105);

  tooth_figure = figure('name',strcat('mcx block ', int2str(mcx_input.nphoton)));
  imagesc(log(im));
  colorbar;

  create_png(im, 'mcx');

end