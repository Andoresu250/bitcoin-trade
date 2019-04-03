require 'test_helper'

class ChargePointsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @charge_point = charge_points(:one)
  end

  test "should get index" do
    get charge_points_url
    assert_response :success
  end

  test "should get new" do
    get new_charge_point_url
    assert_response :success
  end

  test "should create charge_point" do
    assert_difference('ChargePoint.count') do
      post charge_points_url, params: { charge_point: { account_type: @charge_point.account_type, iban: @charge_point.iban, number: @charge_point.number, owner: @charge_point.owner, owner_identification: @charge_point.owner_identification } }
    end

    assert_redirected_to charge_point_url(ChargePoint.last)
  end

  test "should show charge_point" do
    get charge_point_url(@charge_point)
    assert_response :success
  end

  test "should get edit" do
    get edit_charge_point_url(@charge_point)
    assert_response :success
  end

  test "should update charge_point" do
    patch charge_point_url(@charge_point), params: { charge_point: { account_type: @charge_point.account_type, iban: @charge_point.iban, number: @charge_point.number, owner: @charge_point.owner, owner_identification: @charge_point.owner_identification } }
    assert_redirected_to charge_point_url(@charge_point)
  end

  test "should destroy charge_point" do
    assert_difference('ChargePoint.count', -1) do
      delete charge_point_url(@charge_point)
    end

    assert_redirected_to charge_points_url
  end
end
