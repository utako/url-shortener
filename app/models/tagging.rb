class Tagging < ActiveRecord::Base
  validate :shortened_url_id, presence: true, uniqueness: true
  validate :tag_id, presence: true, uniqueness: true

  belongs_to(
    :shortened_url,
    class_name: "ShortenedUrl",
    foreign_key: :shortened_url_id,
    primary_key: :id
  )

  belongs_to(
    :tag_topic,
    class_name: "TagTopic",
    foreign_key: :tag_id,
    primary_key: :id
  )

  def self.tag_url!(shortened_url, tag_topic)
    attrs = { shortened_url_id: shortened_url.id,
              tag_id: tag_topic.id }
    self.create!(attrs)
  end

end