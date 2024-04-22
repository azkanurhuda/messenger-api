class CreateChats < ActiveRecord::Migration[6.1]
  def change
    create_table :chats do |t|
      t.integer :sender_id
      t.integer :conversation_id
      t.integer :parent_id
      t.string :message
      t.boolean :is_read, default: false

      t.timestamps
    end
  end
end
