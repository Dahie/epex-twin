# frozen_string_literal: true

class DataRecord < ApplicationRecord
  validates :unit, presence: true
  validates :source, presence: true

  def value_with_unit
    "#{value} #{unit}"
  end
end
