require 'rails_helper'

RSpec.describe 'タスク管理機能', type: :system do
  describe '登録機能' do
    context 'タスクを登録した場合' do
      it '登録したタスクが表示される' do
        visit new_task_path
        fill_in 'task_title', with: '書類作成'
        fill_in 'task_content', with: '企画書を作成する。'
        click_button '登録する'
        expect(page).to have_content '書類作成'
      end
    end
  end

  describe '一覧表示機能' do

    # let! を使用　テストデータを用意
    let!(:task1) { FactoryBot.create(:task, title: 'first_task', created_at: '2022-02-18') }
    let!(:task2) { FactoryBot.create(:task, title: 'second_task', created_at: '2022-02-17') }
    let!(:task3) { FactoryBot.create(:task, title: 'third_task', created_at: '2022-02-16') }

    # beforeブロックを使用 共通のセットアップ
    before do
      visit tasks_path
    end

    context '一覧画面に遷移した場合' do
      it '作成済みのタスク一覧が作成日時の降順で表示される' do
        task_list = all('.task-title').map(&:text)
        expect(task_list).to eq ['first_task', 'second_task', 'third_task']
      end
    end
    context '新たにタスクを作成した場合' do
      it '新しいタスクが一番上に表示される' do
        visit new_task_path
        fill_in 'task_title', with: '新しいタスク'
        fill_in 'task_content', with: '新しいタスクの内容'
        click_button '登録する'
        visit tasks_path
        task_list = all('.task-title').map(&:text)
        expect(task_list.first).to eq '新しいタスク'
      end
    end
  end

  describe '詳細表示機能' do
     context '任意のタスク詳細画面に遷移した場合' do
       it 'そのタスクの内容が表示される' do
        task = FactoryBot.create(:task, title: '詳細表示テスト', content: '詳細表示テスト')
        visit task_path(task)
        expect(page).to have_content '詳細表示テスト'
       end
     end
  end
end