# frozen_string_literal: true

class DataRecord < ApplicationRecord
  validates :type, presence: true
  validates :value, presence: true
  validates :unit, presence: true
  validates :source, presence: true

  def value_with_unit
    "#{value} #{unit}"
  end

  def self.find_at_starts_at(time)
    find_by(starts_at: time.strftime('%Y-%m-%d %H:%M:%S.000'))
  end
end
