class Company < ApplicationRecord
  EMAIL_VALIDATOR_REGEX = /\A[\w+\-.]+@getmainstreet\.com\z/i.freeze
  EMAIL_INVALID_ERROR = "Valid email domains should be getmainstreet".freeze
  has_rich_text :description

  before_validation :set_city_state, if: :zip_code_changed?

  validates :email,
            format: { with: EMAIL_VALIDATOR_REGEX, message: EMAIL_INVALID_ERROR },
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
      self.state = data[:state_code]
      self.city = data[:city]
    else
      errors.add(:zip_code, "is not valid")
    end
  end

end
