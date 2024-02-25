# frozen_string_literal: true

class CreateDataRecords < ActiveRecord::Migration[7.1]
  def change
    create_table :data_records do |t|
      t.string :type, index: true
      t.float :value
      t.string :unit
      t.string :source
      t.datetime :starts_at
      t.datetime :ends_at
      t.timestamps
    end
  end
end
