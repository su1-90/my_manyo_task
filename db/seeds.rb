# 50.times do |n|
#   Task.create!(
#     title: "タスクタイトル #{n+1}",
#     content: "タスク内容 #{n+1}",
#     created_at: Time.now,
#     updated_at: Time.now
#   )
# end
begin
  admin_user = User.create!(
    name: "Admin User",
    email: "admin@example.com",
    password: "password",
    password_confirmation: "password",
    admin: true
  )

  Task.create!(
    [
      { title: 'first_task', content: '任意の内容1', deadline_on: '2022-02-18', priority: :medium, status: :not_started },
      { title: 'second_task', content: '任意の内容2', deadline_on: '2022-02-17', priority: :high, status: :in_progress },
      { title: 'third_task', content: '任意の内容3', deadline_on: '2022-02-16', priority: :low, status: :completed },
      { title: 'fourth_task', content: '任意の内容4', deadline_on: '2022-02-15', priority: :medium, status: :not_started },
      { title: 'fifth_task', content: '任意の内容5', deadline_on: '2022-02-14', priority: :high, status: :in_progress },
      { title: 'sixth_task', content: '任意の内容6', deadline_on: '2022-02-13', priority: :low, status: :completed },
      { title: 'seventh_task', content: '任意の内容7', deadline_on: '2022-02-12', priority: :medium, status: :not_started },
      { title: 'eighth_task', content: '任意の内容8', deadline_on: '2022-02-11', priority: :high, status: :in_progress },
      { title: 'ninth_task', content: '任意の内容9', deadline_on: '2022-02-10', priority: :low, status: :completed },
      { title: 'tenth_task', content: '任意の内容10', deadline_on: '2022-02-09', priority: :medium, status: :not_started }
    ]
  )
rescue ActiveRecord::RecordInvalid => e
  puts e.record.errors.full_messages
end