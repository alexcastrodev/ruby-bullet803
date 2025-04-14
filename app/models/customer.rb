require "active_record"

class Customer < ActiveRecord::Base
  belongs_to :user
  has_many :addresses, dependent: :destroy, class_name: 'CustomerAddress'
  accepts_nested_attributes_for :addresses, allow_destroy: true
  before_save :save_method

  def save_method
    return unless self.addresses.any? { |tp| tp.new_record? || tp.main_changed? || (tp.main? && tp.marked_for_destruction?) }

    puts "Saving customer with new addresses"
  end
end
