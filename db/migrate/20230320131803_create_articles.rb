class CreateArticles < ActiveRecord::Migration[7.0]
  def change
    create_table :articles do |t|
      t.string :title
      t.references :user, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.boolean :active, default: false

      t.timestamps
    end
  end
end
