# frozen_string_literal: true

# hjg
class AddAdminToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :admin, :boolean, default: false
  end
end
