class AddRandomCategoryToOption < ActiveRecord::Migration[6.0]
  def change
    add_column :options, :random_category, :integer
  end
end
