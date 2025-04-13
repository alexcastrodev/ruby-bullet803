require "active_record"

class Workshop < ActiveRecord::Base
  has_many :inventory_items, inverse_of: :workshop, dependent: :destroy
  accepts_nested_attributes_for :inventory_items
end
