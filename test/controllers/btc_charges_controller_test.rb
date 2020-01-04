require 'test_helper'

class BtcChargesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @btc_charge = btc_charges(:one)
  end

  test "should get index" do
    get btc_charges_url
    assert_response :success
  end

  test "should get new" do
    get new_btc_charge_url
    assert_response :success
  end

  test "should create btc_charge" do
    assert_difference('BtcCharge.count') do
      post btc_charges_url, params: { btc_charge: { btc: @btc_charge.btc, evidence: @btc_charge.evidence, person_id: @btc_charge.person_id, qr: @btc_charge.qr, state: @btc_charge.state } }
    end

    assert_redirected_to btc_charge_url(BtcCharge.last)
  end

  test "should show btc_charge" do
    get btc_charge_url(@btc_charge)
    assert_response :success
  end

  test "should get edit" do
    get edit_btc_charge_url(@btc_charge)
    assert_response :success
  end

  test "should update btc_charge" do
    patch btc_charge_url(@btc_charge), params: { btc_charge: { btc: @btc_charge.btc, evidence: @btc_charge.evidence, person_id: @btc_charge.person_id, qr: @btc_charge.qr, state: @btc_charge.state } }
    assert_redirected_to btc_charge_url(@btc_charge)
  end

  test "should destroy btc_charge" do
    assert_difference('BtcCharge.count', -1) do
      delete btc_charge_url(@btc_charge)
    end

    assert_redirected_to btc_charges_url
  end
end
