class CreateDecryptions < ActiveRecord::Migration
  def change
    create_table :decryptions do |t|
	    t.string :code
	    t.string :keystream

      t.timestamps null: false
    end
  end
end
