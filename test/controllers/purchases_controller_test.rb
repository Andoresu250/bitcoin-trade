require 'test_helper'

class PurchasesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @purchase = purchases(:one)
  end

  test "should get index" do
    get purchases_url
    assert_response :success
  end

  test "should get new" do
    get new_purchase_url
    assert_response :success
  end

  test "should create purchase" do
    assert_difference('Purchase.count') do
      post purchases_url, params: { purchase: { bank_account_id: @purchase.bank_account_id, btc: @purchase.btc, country_id: @purchase.country_id, deposit_evidence: @purchase.deposit_evidence, person_id: @purchase.person_id, state: @purchase.state, transfer_evidence: @purchase.transfer_evidence, value: @purchase.value } }
    end

    assert_redirected_to purchase_url(Purchase.last)
  end

  test "should show purchase" do
    get purchase_url(@purchase)
    assert_response :success
  end

  test "should get edit" do
    get edit_purchase_url(@purchase)
    assert_response :success
  end

  test "should update purchase" do
    patch purchase_url(@purchase), params: { purchase: { bank_account_id: @purchase.bank_account_id, btc: @purchase.btc, country_id: @purchase.country_id, deposit_evidence: @purchase.deposit_evidence, person_id: @purchase.person_id, state: @purchase.state, transfer_evidence: @purchase.transfer_evidence, value: @purchase.value } }
    assert_redirected_to purchase_url(@purchase)
  end

  test "should destroy purchase" do
    assert_difference('Purchase.count', -1) do
      delete purchase_url(@purchase)
    end

    assert_redirected_to purchases_url
  end
end
