class CreateFacebookposts < ActiveRecord::Migration
  def change
    create_table :facebookposts do |t|
      t.string :post
      t.string :post_id
      t.integer :user_id

      t.timestamps
    end
    add_index :facebookposts, [:user_id, :created_at]
  end
end
