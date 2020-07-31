class Company < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[-a-zA-Z0-9.'’&_%+]+@getmainstreet\.com\z/.freeze
  EMAIL_INVALID_ERROR = "Valid email domains should have getmainstreet".freeze
  has_rich_text :description

  before_validation :set_city_state, if: :zip_code_changed?

  validates :email,
            format: { with: VALID_EMAIL_REGEX, message: EMAIL_INVALID_ERROR },
            allow_blank: true,
            unless: proc { transaction_include_any_action?([:destroy]) }

  validates :zip_code, presence: true

  def city_state
    "#{city}, #{state}"
  end

  private

  def set_city_state
    data = ZipCodes.identify(zip_code)

    if data.present?
      state = data[:state_code]
      city = data[:city]
    else
      errors.add(:zip_code, "not found")
    end
  end

end
