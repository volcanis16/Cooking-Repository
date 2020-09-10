class CreateOptions < ActiveRecord::Migration[6.0]
  def change
    create_table :options do |t|
      t.date :randomDate

      t.timestamps
    end
  end
end
