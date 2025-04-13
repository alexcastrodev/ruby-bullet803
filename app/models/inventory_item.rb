require "active_record"

class InventoryItem < ActiveRecord::Base
  belongs_to :workshop, inverse_of: :inventory_items
  belongs_to :car
end
