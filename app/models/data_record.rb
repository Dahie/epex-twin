# frozen_string_literal: true

class DataRecord < ApplicationRecord
  validates :unit, presence: true
end
