require "active_record"

class Workshop < ActiveRecord::Base
  has_one :inventory_item
  accepts_nested_attributes_for :inventory_item
end
