class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.string :name
      t.string :address
      t.text :description
      t.datetime :start_at
      t.datetime :end_at
      t.integer :category
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
