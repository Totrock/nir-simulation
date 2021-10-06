function [srcdef, detpos] = default_block_mcx()
  srcdef.srctype = 'disk';
  srcdef.srcpos = [256 256/2 128];
  srcdef.srcdir = [-1 0 0];
  srcdef.srcparam1 = 200;

  detpos = [65 256/2 256/2 90];
end
