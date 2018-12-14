require "application_system_test_case"

class DocumentTypesTest < ApplicationSystemTestCase
  setup do
    @document_type = document_types(:one)
  end

  test "visiting the index" do
    visit document_types_url
    assert_selector "h1", text: "Document Types"
  end

  test "creating a Document type" do
    visit document_types_url
    click_on "New Document Type"

    fill_in "Abbreviation", with: @document_type.abbreviation
    fill_in "Country", with: @document_type.country_id
    fill_in "Name", with: @document_type.name
    click_on "Create Document type"

    assert_text "Document type was successfully created"
    click_on "Back"
  end

  test "updating a Document type" do
    visit document_types_url
    click_on "Edit", match: :first

    fill_in "Abbreviation", with: @document_type.abbreviation
    fill_in "Country", with: @document_type.country_id
    fill_in "Name", with: @document_type.name
    click_on "Update Document type"

    assert_text "Document type was successfully updated"
    click_on "Back"
  end

  test "destroying a Document type" do
    visit document_types_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Document type was successfully destroyed"
  end
end
