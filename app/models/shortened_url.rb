require 'securerandom'

class ShortenedUrl < ActiveRecord::Base


  belongs_to(
    :submitter,
    class_name: "User",
    foreign_key: :submitter_id,
    primary_key: :id
  )

  has_many(
    :visits,
    class_name: "Visit",
    foreign_key: :shortened_url_id,
    primary_key: :id
  )

  has_many(
    :taggings,
    class_name: "Tagging",
    foreign_key: :shortened_url_id,
    primary_key: :id
  )

  has_many :tags, through: :taggings, source: :tag_topic

  has_many :visitors, -> { distinct }, through: :visits, source: :visitor

  validates :short_url, presence: true, uniqueness: true
  validates :long_url, presence: true, length: { maximum: 1024 }
  validates :submitter_id, presence: true
  validates :max_recent_submits_is_five

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

  def num_clicks
    Visit.where(shortened_url_id: self.id).count
  end

  def num_uniques
    Visit.where(shortened_url_id: self.id).distinct.count(:submitter_id)
  end

  def num_recent_uniques(time = 10)
    where_opts = {
      shortened_url_id: self.id,
      created_at: (time.minutes.ago..Time.now)
    }

    Visit.where(where_opts).distinct.count(:submitter_id)
  end

  private
    def max_recent_submits_is_five
      where_opts = {
        submitter_id: submitter_id,
        created_at: (1.minutes.ago..Time.now)
      }

      if ShortenedUrl.where(where_opts).count < 5
        errors[:submitter_id] << "can't submit more than 5 URLs in one minute"
      end
    end
end