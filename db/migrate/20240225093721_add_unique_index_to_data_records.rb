# frozen_string_literal: true

class AddUniqueIndexToDataRecords < ActiveRecord::Migration[7.1]
  def change
    add_index :data_records, [:starts_at, :ends_at, :type], unique: true
  end
end
