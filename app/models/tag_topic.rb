class TagTopic < ActiveRecord::Base
  validate :name, uniqueness: true, presence: true

  has_many(
    :taggings,
    class_name: "Tagging",
    foreign_key: :tag_id,
    primary_key: :id
  )

  has_many :urls, through: :taggings, source: :url

end