class CreateJoinTableOptionTag < ActiveRecord::Migration[6.0]
  def change
    create_join_table :options, :tags do |t|
      # t.index [:option_id, :tag_id]
      # t.index [:tag_id, :option_id]
    end
  end
end
