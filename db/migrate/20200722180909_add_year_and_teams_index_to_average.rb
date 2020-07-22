# frozen_string_literal: true

class AddYearAndTeamsIndexToAverage < ActiveRecord::Migration[6.0]
  def up
    execute "CREATE EXTENSION IF NOT EXISTS btree_gin;"
    add_index :averages, [:year, :teams], using: :gin
  end

  def down
    remove_index :averages, [:year, :teams]
    execute "DROP EXTENSION IF EXISTS btree_gin;"
  end
end
