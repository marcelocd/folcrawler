class CreateArticles < ActiveRecord::Migration[6.1]
  def change
    create_table :articles do |t|
      t.string :source
      t.string :title
      t.string :url
      t.datetime :published_at
      t.datetime :collected_at
      t.text :body

      t.timestamps
    end
  end
end
