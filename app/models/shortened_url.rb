require 'securerandom'

class ShortenedUrl < ActiveRecord::Base


  belongs_to(
    :submitter,
    class_name: "User",
    foreign_key: :submitter_id,
    primary_key: :id
  )

  validates :short_url, presence: true, uniqueness: true
  validates :long_url, presence: true
  validates :submitter_id, presence: true

  def self.random_code
    loop do
      r_code = SecureRandom.urlsafe_base64
      return r_code unless self.pluck(:short_url).include?(r_code)
    end
  end

  def self.create_for_user_and_long_url!(user, long_url)
    attrs = {
      submitter_id: user.id,
      long_url: long_url,
      short_url: self.random_code
    }

    self.create!(attrs)
  end
end

