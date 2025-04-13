require "active_record"

class InventoryItem < ActiveRecord::Base
  belongs_to :workshop, inverse_of: :inventory_item
  belongs_to :car
end
