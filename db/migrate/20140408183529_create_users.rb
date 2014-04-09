class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string  :name
      t.string  :email
      t.string  :picture_link
      t.string  :gender
      t.string  :locale

      t.integer  :f_id,         :limit => 8
      t.string   :f_token
      t.string   :f_first_name
      t.string   :f_middle_name
      t.string   :f_last_name
      t.string   :f_username
      t.string   :f_location
      t.string   :f_location_id
      t.string   :f_link
      t.integer  :f_timezone
      t.datetime :f_updated_time
      t.boolean  :f_verified
      t.boolean  :f_expires
      t.datetime :f_expires_at

      t.integer  :x
      t.integer  :y
      t.text     :description
      t.boolean  :published, :default => false

      t.timestamps
    end

    add_index :users, :f_id, :unique => true
    add_index :users, :published
    add_index :users, [:x, :y]
  end
end

