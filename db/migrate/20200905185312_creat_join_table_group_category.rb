class CreatJoinTableGroupCategory < ActiveRecord::Migration[6.0]
  def change
    create_join_table :groups, :categories do |t|
      # t.index [:group_id, :category_id]
      # t.index [:category_id, :group_id]
    end
  end
end
