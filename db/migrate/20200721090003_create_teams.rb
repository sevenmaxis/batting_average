# frozen_string_literal: true

class CreateTeams < ActiveRecord::Migration[6.0]
  def change
    create_table :teams, id: :string do |t|
      t.string :name

      t.timestamps
    end
  end
end
