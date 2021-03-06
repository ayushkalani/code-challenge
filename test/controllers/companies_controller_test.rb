require "test_helper"
require "application_system_test_case"

class CompaniesControllerTest < ApplicationSystemTestCase

  def setup
    @company = companies(:hometown_painting)
  end

  test "Index" do
    visit companies_path

    assert_text "Companies"
    assert_text "Hometown Painting"
    assert_text "Wolf Painting"
  end

  test "Show" do
    visit company_path(@company)

    assert_text @company.name
    assert_text @company.phone
    assert_text @company.email
    assert_text @company.city_state
  end

  test "Update with valid zip_code" do
    visit edit_company_path(@company)
    zip_code = Faker::Address.zip_code
    within("form#edit_company_#{@company.id}") do
      fill_in("company_name", with: "Updated Test Company")
      fill_in("company_zip_code", with: zip_code)
      click_button "Update Company"
    end

    assert_text "Changes Saved"
    @company.reload
    assert_equal "Updated Test Company", @company.name
    assert_equal zip_code, @company.zip_code
  end

  test "Update with invalid zip_code" do
    visit edit_company_path(@company)

    within("form#edit_company_#{@company.id}") do
      fill_in("company_name", with: "Updated Test Company")
      fill_in("company_zip_code", with: "0")
      click_button "Update Company"
    end

    assert_text "zip_code not found"
  end

  test "Update with invalid email" do
    visit edit_company_path(@company)

    within("form#edit_company_#{@company.id}") do
      fill_in("company_name", with: "Updated Test Company")
      fill_in("company_zip_code", with: Faker::Address.zip_code)
      fill_in("company_email", with: Faker::Internet.email)
      click_button "Update Company"
    end

    assert_text "Valid email domains should have getmainstreet"
  end

  test "Update with valid email" do
    visit edit_company_path(@company)

    within("form#edit_company_#{@company.id}") do
      fill_in("company_name", with: "Updated Test Company")
      fill_in("company_zip_code", with: Faker::Address.zip_code)
      fill_in("company_email", with: "hello@getmainstreet.com")
      click_button "Update Company"
    end

    assert_text "Changes Saved"

    @company.reload
    assert_equal "Updated Test Company", @company.name
    assert_equal "hello@getmainstreet.com", @company.email
  end

  test "Create" do
    visit new_company_path

    within("form#new_company") do
      fill_in("company_name", with: "New Test Company")
      fill_in("company_zip_code", with: "28173")
      fill_in("company_phone", with: "5553335555")
      fill_in("company_email", with: "new_test_company@test.com")
      click_button "Create Company"
    end

    assert_text "Saved"

    last_company = Company.last
    assert_equal "New Test Company", last_company.name
    assert_equal "28173", last_company.zip_code
  end

  test "delete" do
    visit company_path(@company)

    accept_confirm do
      click_link "Delete"
    end
    assert_text I18n.t("compaines.destroy", name: @company.name)
    assert_text "Create a Company"
  end

  test "delete failure" do
    allow_any_instance_of(Company).to receive(:destroy).and_return(false)
    visit company_path(@company)

    dismiss_confirm do
      click_link "Delete"
    end
    assert_text I18n.t("compaines.errors.destroy", name: @company.name)
  end

end
