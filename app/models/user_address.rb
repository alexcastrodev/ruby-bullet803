require "active_record"

class UserAddress < ActiveRecord::Base
  scope :main, -> () { where(main: true) }

  belongs_to :user, inverse_of: :addresses
end
