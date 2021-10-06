function [srcdef, detdef] = default_block_mmc()
  x_mm_block = 20.480;
  y_mm_block = 20.480;
  z_mm_block = 20.480;

  srcdir = [-1 0 0];
  srcdir = srcdir/norm(srcdir);
  srcpos = [x_mm_block y_mm_block/2 z_mm_block/2];
  srcparam1 = [11 0 0];
  srcdef=struct('srctype','disk',
                'srcpos',srcpos,
                'srcdir',srcdir,
                'srcparam1',srcparam1); 
               
  detsize = 13;
  detpos = [5 y_mm_block/2-detsize/2 z_mm_block/2-detsize/2];
  detdef =struct('srctype','planar',
                'srcpos',detpos,
                'srcdir',[1 0 0],
                'srcparam1',[0 detsize 0],
                'srcparam2',[0 0 detsize]); 
end
