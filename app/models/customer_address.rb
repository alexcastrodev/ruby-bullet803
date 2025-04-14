require "active_record"

class CustomerAddress < ActiveRecord::Base
  belongs_to :user, inverse_of: :addresses
  belongs_to :customer, autosave: true
  validates :city, presence: true
end
