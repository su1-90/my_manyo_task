require 'rails_helper'

RSpec.describe 'タスク管理機能', type: :system do
  describe '登録機能' do
    context 'タスクを登録した場合' do
      it '登録したタスクが表示される' do
        visit new_task_path
        fill_in 'task_title', with: '書類作成'
        fill_in 'task_content', with: '企画書を作成する。'
        # fill_in 'task_deadline_on', with: '2022-02-18'  # テキスト形式で日付を入力
        page.execute_script("document.getElementById('task_deadline_on').value = '2022-02-19'")
        select '中', from: 'task_priority'
        select '未着手', from: 'task_status'
        click_button '登録する'
        expect(page).to have_content '書類作成'
      end
    end
  end

  describe '一覧表示機能' do
    # let! を使用してテストデータを用意
    let!(:task1) { FactoryBot.create(:task, title: 'first_task', deadline_on: '2022-02-18', priority: :medium, status: :not_started) }
    let!(:task2) { FactoryBot.create(:task, title: 'second_task', deadline_on: '2022-02-17', priority: :high, status: :in_progress) }
    let!(:task3) { FactoryBot.create(:task, title: 'third_task', deadline_on: '2022-02-16', priority: :low, status: :completed) }
    # beforeブロックを使用 共通のセットアップ
    before do
      visit tasks_path
    end

    context '一覧画面に遷移した場合' do
      it '作成済みのタスク一覧が作成日時の降順で表示される' do
        task_list = all('.task-title').map(&:text)
        expect(task_list).to eq ['third_task', 'second_task', 'first_task']
      end
    end

    context '新たにタスクを作成した場合' do
      it '新しいタスクが一番上に表示される' do
        visit new_task_path
        fill_in 'task_title', with: '新しいタスク'
        fill_in 'task_content', with: '新しいタスクの内容'
        # fill_in 'task_deadline_on', with: '2022-02-19'  # テキスト形式で日付を入力
        page.execute_script("document.getElementById('task_deadline_on').value = '2022-02-19'")
        select '中', from: 'task_priority'
        select '未着手', from: 'task_status'
        click_button '登録する'
        visit tasks_path
        task_list = all('.task-title').map(&:text)
        expect(task_list.first).to eq '新しいタスク'
      end
    end

    describe 'ソート機能' do
      context '「終了期限」というリンクをクリックした場合' do
        it '終了期限昇順に並び替えられたタスク一覧が表示される' do
          click_link '終了期限'
          sleep 1
          task_list = all('.task-title').map(&:text)
          expect(task_list).to eq ['third_task', 'second_task', 'first_task']
        end
      end

      context '「優先度」というリンクをクリックした場合' do
        it '優先度の高い順に並び替えられたタスク一覧が表示される' do
          click_link '優先度'
          sleep 1
          task_list = all('.task-title').map(&:text)
          expect(task_list).to eq ['second_task', 'first_task', 'third_task']
        end
      end
    end

    describe '検索機能' do
      context 'タイトルであいまい検索をした場合' do
        it '検索ワードを含むタスクのみ表示される' do
          fill_in 'search_title', with: 'first'
          click_button '検索'
          expect(page).to have_content 'first_task'
          expect(page).not_to have_content 'second_task'
          expect(page).not_to have_content 'third_task'
        end
      end

      context 'ステータスで検索した場合' do
        it '検索したステータスに一致するタスクのみ表示される' do
          select '未着手', from: 'search_status'
          click_button '検索'
          expect(page).to have_content 'first_task'
          expect(page).not_to have_content 'second_task'
          expect(page).not_to have_content 'third_task'
        end
      end

      context 'タイトルとステータスで検索した場合' do
        it '検索ワードをタイトルに含み、かつステータスに一致するタスクのみ表示される' do
          fill_in 'search_title', with: 'first'
          select '未着手', from: 'search_status'
          click_button '検索'
          expect(page).to have_content 'first_task'
          expect(page).not_to have_content 'second_task'
          expect(page).not_to have_content 'third_task'
        end
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
