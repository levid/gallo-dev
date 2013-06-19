# encoding: utf-8

class FilelessIO < StringIO
  attr_accessor :original_filename
  attr_accessor :content_type
end


class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick

  attr_accessor :content_type, :original_filename, :image_data
  before :save, :decode_base64_image

  # before :cache, :convert_base64

  # def convert_base64(file)
  #   if file.respond_to?(:original_filename) && file.original_filename.match(/^base64:/)
  #     fname = file.original_filename.gsub(/^base64:/, '')
  #     ctype = file.content_type
  #     decoded = Base64.decode64(file.read)
  #     file.file.tempfile.close!
  #     decoded = FilelessIO.new(decoded)
  #     decoded.original_filename = fname
  #     decoded.content_type = ctype
  #     file.__send__ :file=, decoded
  #   end
  #   file
  # end

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  # Include the Sprockets helpers for Rails 3.1+ asset pipeline compatibility:
  # include Sprockets::Helpers::RailsHelper
  # include Sprockets::Helpers::IsolatedHelper

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process :scale => [50, 50]
  # end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg svg png)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

  version :thumb do
    process :resize_to_limit => [200, 200]
  end

  version :web do
    process :resize_to_fit  => [1000, 1000]
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  def filename
    if original_filename
    Time.new.to_i.to_s+"_"+original_filename
    end
  end

  protected
    def decode_base64_image
      if image_data && content_type && original_filename
        decoded_data = Base64.decode64(image_data)

        data = StringIO.new(decoded_data)
        data.class_eval do
          attr_accessor :content_type, :original_filename
        end

        data.content_type = content_type
        data.original_filename = File.basename(original_filename)

        self.image = data
      end
    end

  #image_uploader, which is mounted to pictures.rb
  # version :caption do

  #   process :caption

  #   # top caption
  #   def caption
  #     manipulate! do |source|
  #       img = Picture.last
  #       answer = Answer.last.top_caption
  #       txt = Magick::Draw.new
  #       txt.pointsize = 40
  #       txt.font_family = "Impact"
  #       txt.gravity = Magick::NorthGravity
  #       txt.stroke = "#000000"
  #       txt.fill = "#ffffff"
  #       txt.font_weight = Magick::BoldWeight
  #       caption = answer
  #       source = source.resize_to_fill!(400, 400).border(10, 10, "black")
  #       source.annotate!(txt, 0, 0, 0, 20, caption)
  #     end

  #     # lower caption
  #     manipulate! do |source|
  #       img = Picture.last
  #       answer = Answer.last.punchline
  #       txt = Magick::Draw.new
  #       txt.pointsize = 40
  #       txt.font_family = "Impact"
  #       txt.gravity = Magick::SouthGravity
  #       txt.stroke = "#000000"
  #       txt.fill = "#ffffff"
  #       txt.font_weight = Magick::BoldWeight
  #       name = answer
  #       source = source.resize_to_fill!(400, 400).border(0, 0, "black")
  #       source.annotate!(txt, 0, 0, 0, 20, name)
  #     end
  #   end
  # end

end