require "application_system_test_case"

class BankAccountsTest < ApplicationSystemTestCase
  setup do
    @bank_account = bank_accounts(:one)
  end

  test "visiting the index" do
    visit bank_accounts_url
    assert_selector "h1", text: "Bank Accounts"
  end

  test "creating a Bank account" do
    visit bank_accounts_url
    click_on "New Bank Account"

    fill_in "Account Certificate", with: @bank_account.account_certificate
    fill_in "Bank", with: @bank_account.bank
    fill_in "Document Type", with: @bank_account.document_type_id
    fill_in "Identification", with: @bank_account.identification
    fill_in "Identification Back", with: @bank_account.identification_back
    fill_in "Identification Front", with: @bank_account.identification_front
    fill_in "Number", with: @bank_account.number
    fill_in "Person", with: @bank_account.person_id
    click_on "Create Bank account"

    assert_text "Bank account was successfully created"
    click_on "Back"
  end

  test "updating a Bank account" do
    visit bank_accounts_url
    click_on "Edit", match: :first

    fill_in "Account Certificate", with: @bank_account.account_certificate
    fill_in "Bank", with: @bank_account.bank
    fill_in "Document Type", with: @bank_account.document_type_id
    fill_in "Identification", with: @bank_account.identification
    fill_in "Identification Back", with: @bank_account.identification_back
    fill_in "Identification Front", with: @bank_account.identification_front
    fill_in "Number", with: @bank_account.number
    fill_in "Person", with: @bank_account.person_id
    click_on "Update Bank account"

    assert_text "Bank account was successfully updated"
    click_on "Back"
  end

  test "destroying a Bank account" do
    visit bank_accounts_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Bank account was successfully destroyed"
  end
end
