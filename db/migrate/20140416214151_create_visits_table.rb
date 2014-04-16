class CreateVisitsTable < ActiveRecord::Migration
  def change
    create_table :visits do |t|
      t.integer :submitter_id, null: false
      t.integer :shortened_url_id, null: false
      t.timestamps
    end

    add_index(:visits, :submitter_id)
    add_index(:visits, :shortened_url_id)
  end
end
