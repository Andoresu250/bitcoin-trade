require "application_system_test_case"

class PurchasesTest < ApplicationSystemTestCase
  setup do
    @purchase = purchases(:one)
  end

  test "visiting the index" do
    visit purchases_url
    assert_selector "h1", text: "Purchases"
  end

  test "creating a Purchase" do
    visit purchases_url
    click_on "New Purchase"

    fill_in "Bank Account", with: @purchase.bank_account_id
    fill_in "Btc", with: @purchase.btc
    fill_in "Country", with: @purchase.country_id
    fill_in "Deposit Evidence", with: @purchase.deposit_evidence
    fill_in "Person", with: @purchase.person_id
    fill_in "State", with: @purchase.state
    fill_in "Transfer Evidence", with: @purchase.transfer_evidence
    fill_in "Value", with: @purchase.value
    click_on "Create Purchase"

    assert_text "Purchase was successfully created"
    click_on "Back"
  end

  test "updating a Purchase" do
    visit purchases_url
    click_on "Edit", match: :first

    fill_in "Bank Account", with: @purchase.bank_account_id
    fill_in "Btc", with: @purchase.btc
    fill_in "Country", with: @purchase.country_id
    fill_in "Deposit Evidence", with: @purchase.deposit_evidence
    fill_in "Person", with: @purchase.person_id
    fill_in "State", with: @purchase.state
    fill_in "Transfer Evidence", with: @purchase.transfer_evidence
    fill_in "Value", with: @purchase.value
    click_on "Update Purchase"

    assert_text "Purchase was successfully updated"
    click_on "Back"
  end

  test "destroying a Purchase" do
    visit purchases_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Purchase was successfully destroyed"
  end
end
