# encoding: utf-8

class PictureUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick
  include CarrierWave::Processing::RMagick

  storage :file
  process :strip # strip image of all profiles and comments

  def store_dir
    "pictures"
  end

  version :big do
    process :resize_to_fill => [300, 300]
    process :quality        => 90
  end

  version :mozaic do
    process :resize_to_fill => [15, 15]
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  def cache_dir
    Rails.root.join 'tmp/uploads'
  end
end
