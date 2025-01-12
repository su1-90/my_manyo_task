class AddTemporaryDetailsToTasks < ActiveRecord::Migration[6.1]
  def change
    add_column :tasks, :deadline_on, :date, default: Date.today
    add_column :tasks, :priority, :integer, default: 0
    add_column :tasks, :status, :integer, default: 0
  end
end
