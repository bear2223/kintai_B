# frozen_string_literal: true

# hjg
class AddDepartmentToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :department, :string
  end
end
