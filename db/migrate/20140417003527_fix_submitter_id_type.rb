class FixSubmitterIdType < ActiveRecord::Migration
  def change
    add_column :shortened_urls, :submitter_id2, :integer
    ShortenedUrl.all.each do |url|
      url.submitter_id2 = url.submitter_id
      url.save!(validate: false)
    end
    remove_column :shortened_urls, :submitter_id
    rename_column :shortened_urls, :submitter_id2, :submitter_id
  end
end
