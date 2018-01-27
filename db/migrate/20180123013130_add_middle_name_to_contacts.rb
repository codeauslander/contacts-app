class AddMiddleNameToContacts < ActiveRecord::Migration[5.1]
  def change
    add_column :contacts, :middle_name, :string
    add_column :contacts, :bio, :text
  end
end
