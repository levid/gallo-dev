class AddImageToCrests < ActiveRecord::Migration
  def change
    add_column :crests, :image, :string
  end
end
