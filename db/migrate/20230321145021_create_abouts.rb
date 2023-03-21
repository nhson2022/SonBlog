class CreateAbouts < ActiveRecord::Migration[7.0]
  def change
    create_table :abouts do |t|
      t.string :ten
      t.string :dia_chi
      t.string :dien_thoai
      t.text :tieu_su
      t.integer :nam_sinh

      t.timestamps
    end
  end
end
