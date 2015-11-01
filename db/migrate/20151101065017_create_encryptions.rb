class CreateEncryptions < ActiveRecord::Migration
  def change
    create_table :encryptions do |t|
	    t.string :message
	    t.string :keystream

      t.timestamps null: false
    end
  end
end
