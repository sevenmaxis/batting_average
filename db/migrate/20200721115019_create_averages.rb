class CreateAverages < ActiveRecord::Migration[6.0]
  def change
    create_table :averages, id: :string do |t|
      t.string :year, null: false
      t.string :teams, array: true, default: []
      t.float :average, default: 0.0

      t.timestamps
    end

    add_index :averages, :teams, using: :gin
    add_index :averages, :year, using: :btree, unique: true
  end
end
