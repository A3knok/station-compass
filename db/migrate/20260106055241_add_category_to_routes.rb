class AddCategoryToRoutes < ActiveRecord::Migration[7.2]
  def change
    add_reference :routes, :category, type: :uuid, foreign_key: true
  end
end
