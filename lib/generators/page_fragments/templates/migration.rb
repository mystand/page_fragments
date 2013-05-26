class CreatePageFragments < ActiveRecord::Migration
  def change
    create_table :page_fragments do |t|
      t.string :key
      t.string :content_type
      t.text :validation
      t.text :content
      t.boolean :hidden, :default => false

      t.timestamps
    end
  end
end