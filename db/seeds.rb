50.times do |n|
  Task.create!(
    title: "タスクタイトル #{n+1}",
    content: "タスク内容 #{n+1}",
    created_at: Time.now,
    updated_at: Time.now
  )
end