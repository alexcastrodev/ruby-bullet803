require_relative "test_helper"
require "bullet"
require "logger"

class BulletTest < Minitest::Test
  def setup
    # Configure Bullet to be active and raise on N+1 query detection
    Bullet.enable = true
    Bullet.raise = true

    # Enable ActiveRecord logging to STDOUT (for debugging purposes)
    ActiveRecord::Base.logger = Logger.new(STDOUT)

    # Clear any existing records
    Workshop.delete_all
    InventoryItem.delete_all
    Car.delete_all

    # Create a Car for the association
    @car1 = Car.create!(name: "Test Car")

    # Start Bullet request tracking
    Bullet.start_request
  end

  def teardown
    Bullet.perform_out_of_channel_notifications if Bullet.notification?
    Bullet.end_request
  end

  def test_eager_loading_no_n_plus_one
    workshop = Workshop.new(
      name: "Test Workshop",
      inventory_item_attributes: {
        car_id: @car1.id,
        quantity: 2
      }
    )

    workshop.save!
  end
end
