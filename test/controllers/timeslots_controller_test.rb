require 'test_helper'

class TimeslotsControllerTest < ActionController::TestCase
  setup do
    @timeslot = timeslots(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:timeslots)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create timeslot" do
    assert_difference('Timeslot.count') do
      post :create, timeslot: { day: @timeslot.day, end_time: @timeslot.end_time, room_id: @timeslot.room_id, start_time: @timeslot.start_time }
    end

    assert_redirected_to timeslot_path(assigns(:timeslot))
  end

  test "should show timeslot" do
    get :show, id: @timeslot
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @timeslot
    assert_response :success
  end

  test "should update timeslot" do
    patch :update, id: @timeslot, timeslot: { day: @timeslot.day, end_time: @timeslot.end_time, room_id: @timeslot.room_id, start_time: @timeslot.start_time }
    assert_redirected_to timeslot_path(assigns(:timeslot))
  end

  test "should destroy timeslot" do
    assert_difference('Timeslot.count', -1) do
      delete :destroy, id: @timeslot
    end

    assert_redirected_to timeslots_path
  end
end
