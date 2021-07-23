class AddModifiedAtToArticles < ActiveRecord::Migration[6.1]
  def change
    add_column :articles, :modified_at, :datetime
  end
end
