class Crest < ActiveRecord::Base
  attr_accessible :gallery_id, :name, :image, :image_data, :remote_image_url
  belongs_to :gallery
  mount_uploader :image, ImageUploader
  # mount_uploader :base64, Base64dataUploader

  def encoded
    Base64.encode64(open(image.current_path){ |io| io.read })
  end

  def decoded(image_data)
    Base64.decode64(image_data)
  end
end
