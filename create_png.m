function create_png(im,filename)
  im_norm=(im-min(im(:)))/(max(im(:))-min(im(:)));
  im_norm = im_norm * 65535;
  im_norm = uint16(im_norm);
  imwrite(im_norm, strcat(filename,'tooth.png'));

  im_log = log(im);
  im_log_norm=(im_log-min(im_log(:)))/(max(im_log(:))-min(im_log(:)));
  im_log_norm = im_log_norm * 65535;
  im_log_norm = uint16(im_log_norm);
  imwrite(im_log_norm, strcat(filename,'tooth-log.png'));
end