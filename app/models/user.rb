require "active_record"

class User < ActiveRecord::Base
  has_many :customers, inverse_of: :user
end
