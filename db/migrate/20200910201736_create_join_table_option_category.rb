class CreateJoinTableOptionCategory < ActiveRecord::Migration[6.0]
  def change
    create_join_table :options, :categories do |t|
      # t.index [:option_id, :category_id]
      # t.index [:category_id, :option_id]
    end
  end
end
