class RemoveNullConstraintFromTimestamp < ActiveRecord::Migration[6.0]
  def up
    change_column_null :averages, :created_at, true
    change_column_null :averages, :updated_at, true
  end

  def down
    change_column_null :averages, :created_at, false
    change_column_null :averages, :updated_at, false
  end
end
