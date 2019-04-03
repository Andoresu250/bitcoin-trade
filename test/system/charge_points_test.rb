require "application_system_test_case"

class ChargePointsTest < ApplicationSystemTestCase
  setup do
    @charge_point = charge_points(:one)
  end

  test "visiting the index" do
    visit charge_points_url
    assert_selector "h1", text: "Charge Points"
  end

  test "creating a Charge point" do
    visit charge_points_url
    click_on "New Charge Point"

    fill_in "Account Type", with: @charge_point.account_type
    fill_in "Iban", with: @charge_point.iban
    fill_in "Number", with: @charge_point.number
    fill_in "Owner", with: @charge_point.owner
    fill_in "Owner Identification", with: @charge_point.owner_identification
    click_on "Create Charge point"

    assert_text "Charge point was successfully created"
    click_on "Back"
  end

  test "updating a Charge point" do
    visit charge_points_url
    click_on "Edit", match: :first

    fill_in "Account Type", with: @charge_point.account_type
    fill_in "Iban", with: @charge_point.iban
    fill_in "Number", with: @charge_point.number
    fill_in "Owner", with: @charge_point.owner
    fill_in "Owner Identification", with: @charge_point.owner_identification
    click_on "Update Charge point"

    assert_text "Charge point was successfully updated"
    click_on "Back"
  end

  test "destroying a Charge point" do
    visit charge_points_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Charge point was successfully destroyed"
  end
end
