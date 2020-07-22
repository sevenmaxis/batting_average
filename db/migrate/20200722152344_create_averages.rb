# frozen_string_literal: true

class CreateAverages < ActiveRecord::Migration[6.0]
  def change
    create_table :averages do |t|
      t.string :player_id, null: false
      t.string :year, null: false
      t.string :teams, array: true, default: []
      t.float :average, default: 0.0

      t.timestamps
    end
  end
end
