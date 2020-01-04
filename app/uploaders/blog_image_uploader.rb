class BlogImageUploader < CarrierWave::Uploader::Base
  
  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  # install this
  # sudo apt-get install libmagickwand-dev
  include CarrierWave::MiniMagick

  storage :fog

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
  
  #Create different versions of your uploaded files:
  version :thumb do
   process resize_to_fit: [200, 200]
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_whitelist
   %w(jpg jpeg gif png)
  end
  
  def content_type_whitelist
    /image\//
  end

end
