class AddRemoteImageUrlToCrests < ActiveRecord::Migration
  def change
    add_column :crests, :remote_image_url, :string
  end
end
