require "application_system_test_case"

class BtcChargesTest < ApplicationSystemTestCase
  setup do
    @btc_charge = btc_charges(:one)
  end

  test "visiting the index" do
    visit btc_charges_url
    assert_selector "h1", text: "Btc Charges"
  end

  test "creating a Btc charge" do
    visit btc_charges_url
    click_on "New Btc Charge"

    fill_in "Btc", with: @btc_charge.btc
    fill_in "Evidence", with: @btc_charge.evidence
    fill_in "Person", with: @btc_charge.person_id
    fill_in "Qr", with: @btc_charge.qr
    fill_in "State", with: @btc_charge.state
    click_on "Create Btc charge"

    assert_text "Btc charge was successfully created"
    click_on "Back"
  end

  test "updating a Btc charge" do
    visit btc_charges_url
    click_on "Edit", match: :first

    fill_in "Btc", with: @btc_charge.btc
    fill_in "Evidence", with: @btc_charge.evidence
    fill_in "Person", with: @btc_charge.person_id
    fill_in "Qr", with: @btc_charge.qr
    fill_in "State", with: @btc_charge.state
    click_on "Update Btc charge"

    assert_text "Btc charge was successfully updated"
    click_on "Back"
  end

  test "destroying a Btc charge" do
    visit btc_charges_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Btc charge was successfully destroyed"
  end
end
