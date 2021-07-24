class DropSourceFromArticles < ActiveRecord::Migration[6.1]
  def change
    remove_column :articles, :source
  end
end
