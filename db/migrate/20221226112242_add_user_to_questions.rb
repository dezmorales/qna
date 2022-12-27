class AddUserToQuestions < ActiveRecord::Migration[6.1]
  def change
    add_belongs_to :questions, :user
  end
end
