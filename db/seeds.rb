# db/seeds.rb

# 一般ユーザの作成
user = User.find_or_create_by!(email: 'user@example.com') do |u|
  u.name = '一般ユーザ'
  u.password = 'password'
  u.password_confirmation = 'password'
  u.admin = false
end

# 管理者の作成
admin = User.find_or_create_by!(email: 'admin@example.com') do |u|
  u.name = '管理者ユーザ'
  u.password = 'password'
  u.password_confirmation = 'password'
  u.admin = true
end

# 一般ユーザのタスクを50件作成
50.times do |n|
  Task.create!(
    title: "一般ユーザのタスク#{n + 1}",
    content: "一般ユーザのタスク#{n + 1}の詳細",
    deadline_on: Date.today + n.days,
    priority: [:low, :medium, :high].sample,
    status: [:not_started, :in_progress, :completed].sample,
    user: user
  )
end

# 管理者ユーザのタスクを50件作成
50.times do |n|
  Task.create!(
    title: "管理者ユーザのタスク#{n + 1}",
    content: "管理者ユーザのタスク#{n + 1}の詳細",
    deadline_on: Date.today + n.days,
    priority: [:low, :medium, :high].sample,
    status: [:not_started, :in_progress, :completed].sample,
    user: admin
  )
end