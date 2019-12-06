class CreateGrams < ActiveRecord::Migration[5.2]
  def change
    create_table :grams do |t|
      t.text :message
      t.string :username
      t.timestamps
    end
  end
end
