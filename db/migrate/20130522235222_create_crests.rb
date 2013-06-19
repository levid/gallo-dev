class CreateCrests < ActiveRecord::Migration
  def self.up
    create_table :crests do |t|
      t.integer :gallery_id
      t.string :name
      t.timestamps
    end
  end

  def self.down
    drop_table :crests
  end
end
