class AddImageToRoutes < ActiveRecord::Migration[7.2]
  def change
    add_column :routes, :images, :jsonb
  end
end
