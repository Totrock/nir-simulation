load detected_photons.mat;

if(isfield(detphoton,'detid'))
  detid = detphoton.detid;
end
if(isfield(detphoton,'nscat'))
  nscat = detphoton.nscat;
end
if(isfield(detphoton,'ppath'))
  ppath = detphoton.ppath;
end
if(isfield(detphoton,'p'))
  p = detphoton.p;
end
if(isfield(detphoton,'v'))
  v = detphoton.v;
end
if(isfield(detphoton,'w0'))
  w0 = detphoton.w0;
end
if(isfield(detphoton,'prop'))
  prop = detphoton.prop;
end
if(isfield(detphoton,'data'))
  data = detphoton.data;
end

