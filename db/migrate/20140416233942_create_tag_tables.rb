class CreateTagTables < ActiveRecord::Migration
  def change
    create_table :tag_topics do |t|
      t.string :name, null: false
      t.timestamps
    end

    create_table :taggings do |t|
      t.integer :shortened_url_id, null: false
      t.integer :tag_id, null: false
      t.timestamps
    end
    add_index(:taggings, :tag_id)
    add_index(:taggings, :shortened_url_id)
  end
end
