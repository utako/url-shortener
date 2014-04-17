
class ChangeLongUrlType < ActiveRecord::Migration
  def change
    change_column :shortened_urls, :long_url, :text
  end
end
