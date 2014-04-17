class Visit < ActiveRecord::Base
  belongs_to(
    :visitor,
    class_name: "User",
    foreign_key: :submitter_id,
    primary_key: :id
  )

  belongs_to(
    :shortened_url,
    class_name: "ShortenedUrl",
    foreign_key: :shortened_url_id,
    primary_key: :id
  )

  validates :visitor, presence: true
  validates :shortened_url, presence: true

  def self.record_visit!(user, shortened_url)
    self.create!(
      submitter_id: user.id,
      shortened_url_id: shortened_url.id
    )
  end
end

