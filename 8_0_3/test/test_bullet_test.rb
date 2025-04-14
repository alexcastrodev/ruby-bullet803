require_relative "test_helper"
require "bullet"
require "logger"

class BulletTest < Minitest::Test
  def setup
    # Clear any existing records
    User.delete_all
    Customer.delete_all
    CustomerAddress.delete_all

    # Configure Bullet to detect and raise on N+1 queries
    Bullet.raise = true
    Bullet.enable = true
    Bullet.unused_eager_loading_enable = false
    
    # Create user
    @user = User.create!(name: "Test User")
    
    # Seed
    @user.customers.create!(name: "Test Customer", addresses: [
      CustomerAddress.create!(city: "Test City", main: true), 
      CustomerAddress.create!(city: "Test City", main: false)
    ])

    # Start Bullet request tracking
    Bullet.start_request
  end

  def teardown
    Bullet.perform_out_of_channel_notifications if Bullet.notification?
    Bullet.end_request
  end

  def test_creating_multiple_main_addresses
    create_params = {
      name: "Test Customer",
      addresses_attributes: [
      { city: "City 1", main: true },
      { city: "City 2", main: true },
      ],
    }
    customer = @user.customers.build(create_params)
    
    customer.save!
  end
end
