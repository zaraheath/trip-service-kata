require 'test/unit'
require 'mocha/test_unit'
require './trip/trip_service'
require './trip/trip'

class TripServiceTests < Test::Unit::TestCase
  def test_raise_exception_when_user_not_logged_in
    UserSession.any_instance.stubs(:get_logged_user).returns(nil)

    assert_raise UserNotLoggedInException do
      TripService.new.get_trip_by_user(User.new)
    end
  end

  def test_trip_list_should_be_empty_when_user_is_not_logged_user_friend
    logged_user = User.new

    UserSession.any_instance.stubs(:get_logged_user).returns(logged_user)

    assert_equal TripService.new.get_trip_by_user(User.new), []
  end

  def test_should_trip_list_be_returned_when_user_is_logged_user_friend
    logged_user = User.new
    user = User.new
    user.add_friend(logged_user)
    expected_trips = [Trip.new, Trip.new]

    UserSession.any_instance.stubs(:get_logged_user).returns(logged_user)
    TripDAO.stubs(:find_trips_by_user).with(user).returns(expected_trips)

    trips = TripService.new.get_trip_by_user(user)
    assert_equal expected_trips, trips
  end
end
