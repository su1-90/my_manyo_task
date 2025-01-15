FactoryBot.define do
  factory :task do
    title { '書類作成' }
    content { '企画書を作成する' }
    deadline_on { '2022-02-18' }
    priority { :medium }
    status { :not_started }
  end
  
  factory :first_task, class: Task do
    title { '書類作成' }
    content { '企画書を作成する。' }
    deadline_on { '2022-02-18' }
    priority { :medium }
    status { :not_started }
  end

  factory :second_task, class: Task do
    title { 'メール送信' }
    content { '顧客へ営業のメールを送る。' }
    deadline_on { '2022-02-17' }
    priority { :high }
    status { :in_progress }
  end

  factory :third_task, class: Task do
    title { 'デザインレビュー' }
    content { '新しいデザインをレビューする。' }
    deadline_on { '2022-02-16' }
    priority { :low }
    status { :completed }
  end
end
