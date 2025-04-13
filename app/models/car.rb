require "active_record"

class Car < ActiveRecord::Base
  has_many :inventory_items
end
