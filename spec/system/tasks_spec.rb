require 'rails_helper'

RSpec.describe 'タスク管理機能', type: :system do
  let!(:user) { FactoryBot.create(:user) }

  before do
    visit new_session_path
    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: user.password
    click_button 'ログイン'
    expect(page).to have_content 'ログインしました'
  end
  

  describe '登録機能' do
    context 'タスクを登録した場合' do
      it '登録したタスクが表示される' do
        visit new_task_path
        fill_in 'タイトル', with: '新しいタスク'
        fill_in '内容', with: 'タスクの詳細'
        click_button '登録する'
        expect(page).to have_current_path(tasks_path)
        expect(page).to have_content '新しいタスク'
        expect(page).to have_content 'タスクの詳細'
      end
    end
  end

  describe '一覧表示機能' do
    context '一覧画面に遷移した場合' do
      it '作成済みのタスク一覧が作成日時の降順で表示される' do
        task1 = FactoryBot.create(:task, title: '最初のタスク', created_at: Time.now - 1.day, user: user)
        task2 = FactoryBot.create(:task, title: '2番目のタスク', created_at: Time.now, user: user)
        visit tasks_path
        expect(task2.title).to appear_before(task1.title)
      end
    end

    context '新たにタスクを作成した場合' do
      it '新しいタスクが一番上に表示される' do
        FactoryBot.create(:task, title: '最初のタスク', user: user)
        visit new_task_path
        fill_in 'タイトル', with: '新しいタスク'
        fill_in '内容', with: 'タスクの詳細'
        click_button '登録する'
        expect(page).to have_content '新しいタスク'
      end
    end

    context 'ソート機能' do
      before do
        @task1 = FactoryBot.create(:task, title: 'タスク1', deadline_on: '2025-01-15', priority: '高', user: user)
        @task2 = FactoryBot.create(:task, title: 'タスク2', deadline_on: '2025-01-10', priority: '中', user: user)
        @task3 = FactoryBot.create(:task, title: 'タスク3', deadline_on: '2025-01-05', priority: '低', user: user)
      end

      context '「終了期限」というリンクをクリックした場合' do
        it '終了期限昇順に並び替えられたタスク一覧が表示される' do
          visit tasks_path(sort_deadline_on: true)
          expect(@task3.title).to appear_before(@task2.title)
          expect(@task2.title).to appear_before(@task1.title)
        end
      end

      context '「優先度」というリンクをクリックした場合' do
        it '優先度の高い順に並び替えられたタスク一覧が表示される' do
          visit tasks_path(sort_priority: true)
          expect(@task1.title).to appear_before(@task2.title)
          expect(@task2.title).to appear_before(@task3.title)
        end
      end
    end

    describe '検索機能' do
      before do
        @task1 = FactoryBot.create(:task, title: 'タスク1', status: '未着手', user: user)
        @task2 = FactoryBot.create(:task, title: 'タスク2', status: '着手中', user: user)
        @task3 = FactoryBot.create(:task, title: 'タスク3', status: '完了', user: user)
      end

      context 'タイトルであいまい検索をした場合' do
        it '検索ワードを含むタスクのみ表示される' do
          visit tasks_path
          fill_in 'search[title]', with: 'タスク1'
          click_button '検索'
          expect(page).to have_content 'タスク1'
          expect(page).not_to have_content 'タスク2'
          expect(page).not_to have_content 'タスク3'
        end
      end

      context 'ステータスで検索した場合' do
        it '検索したステータスに一致するタスクのみ表示される' do
          visit tasks_path
          select '未着手', from: 'search[status]'
          click_button '検索'
          expect(page).to have_content 'タスク1'
          expect(page).not_to have_content 'タスク2'
          expect(page).not_to have_content 'タスク3'
        end
      end

      context 'タイトルとステータスで検索した場合' do
        it '検索ワードをタイトルに含み、かつステータスに一致するタスクのみ表示される' do
          visit tasks_path
          fill_in 'search[title]', with: 'タスク'
          select '着手中', from: 'search[status]'
          click_button '検索'
          expect(page).to have_content 'タスク2'
          expect(page).not_to have_content 'タスク1'
          expect(page).not_to have_content 'タスク3'
        end
      end
    end

    describe '詳細表示機能' do
      context '任意のタスク詳細画面に遷移した場合' do
        it 'そのタスクの内容が表示される' do
          task = FactoryBot.create(:task, title: '詳細タスク', content: '詳細内容', user: user)
          visit task_path(task)
          expect(page).to have_content '詳細タスク'
          expect(page).to have_content '詳細内容'
        end
      end
    end
  end
end
