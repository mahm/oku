class AddIntroductionToUsers < ActiveRecord::Migration
  def change
    add_column :users, :intoroduction, :text
  end
end
