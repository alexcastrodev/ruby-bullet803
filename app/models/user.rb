require "active_record"

class User < ActiveRecord::Base
  has_many :customers, inverse_of: :user

  has_many :addresses, class_name: 'UserAddress', dependent: :destroy, inverse_of: :user
  accepts_nested_attributes_for :addresses, allow_destroy: true
end
