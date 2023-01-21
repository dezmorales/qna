class AddColumnBestAnswerToQuestions < ActiveRecord::Migration[6.1]
  def change
    add_belongs_to :questions, :best_answer, foreign_key: { to_table: :answers }
  end
end

