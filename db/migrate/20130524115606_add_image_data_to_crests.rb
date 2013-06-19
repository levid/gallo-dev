class AddImageDataToCrests < ActiveRecord::Migration
  def change
    add_column :crests, :image_data, :text
  end
end
