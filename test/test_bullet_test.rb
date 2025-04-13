require_relative "test_helper"
require "bullet"

class BulletTest < Minitest::Test
  def setup
    Bullet.start_request

    # Clear any existing records
    Workshop.delete_all
    InventoryItem.delete_all
    Car.delete_all

    # Create a Car for the association
    @car1 = Car.create!(name: "Test Car")
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
