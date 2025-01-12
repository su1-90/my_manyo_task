class ChangeDetailsInTasks < ActiveRecord::Migration[6.1]
  def change
    change_column_default :tasks, :deadline_on, from: Date.today, to: nil
    change_column_default :tasks, :priority, from: 0, to: nil
    change_column_default :tasks, :status, from: 0, to: nil

    change_column_null :tasks, :deadline_on, false
    change_column_null :tasks, :priority, false
    change_column_null :tasks, :status, false
  end
end
