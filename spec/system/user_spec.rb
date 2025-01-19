require 'rails_helper'

RSpec.describe 'ユーザ管理機能', type: :system do
  let!(:user) { FactoryBot.create(:user) }
  let!(:admin_user) { FactoryBot.create(:admin_user) }

  describe '登録機能' do
    context 'ユーザを登録した場合' do
      it 'タスク一覧画面に遷移する' do
        visit new_user_path
        fill_in '名前', with: '新規ユーザ'
        fill_in 'メールアドレス', with: 'new@example.com'
        fill_in 'パスワード', with: 'password'
        fill_in 'パスワード（確認）', with: 'password'
        click_button '登録する'
        expect(page).to have_content 'タスク一覧'
      end
    end

    context 'ログインせずにタスク一覧画面に遷移した場合' do
      it 'ログイン画面に遷移し、「ログインしてください」というメッセージが表示される' do
        visit tasks_path
        expect(page).to have_content 'ログインしてください'
      end
    end
  end

  describe 'ログイン機能' do
    context '登録済みのユーザでログインした場合' do
      before do
        visit new_session_path
        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード', with: user.password
        click_button 'ログイン'
      end

      it 'タスク一覧画面に遷移し、「ログインしました」というメッセージが表示される' do
        expect(page).to have_content 'ログインしました'
        expect(page).to have_content 'タスク一覧'
      end

      it '自分の詳細画面にアクセスできる' do
        visit user_path(user)
        expect(page).to have_content user.name
        expect(page).to have_content user.email
      end

      it '他人の詳細画面にアクセスすると、タスク一覧画面に遷移する' do
        visit user_path(admin_user)
        expect(page).to have_content 'タスク一覧'
      end

      it 'ログアウトするとログイン画面に遷移し、「ログアウトしました」というメッセージが表示される' do
        click_link 'ログアウト'
        expect(page).to have_content 'ログアウトしました'
      end
    end
  end

  describe '管理者機能' do
    context '管理者がログインした場合' do
      before do
        visit new_session_path
        fill_in 'メールアドレス', with: admin_user.email
        fill_in 'パスワード', with: admin_user.password
        click_button 'ログインする'
      end

      it 'ユーザ一覧画面にアクセスできる' do
        visit admin_users_path
        expect(page).to have_content 'ユーザ一覧'
      end

      it '管理者を登録できる' do
        visit new_admin_user_path
        fill_in '名前', with: '新規管理者'
        fill_in 'メールアドレス', with: 'new_admin@example.com'
        fill_in 'パスワード', with: 'password'
        fill_in 'パスワード（確認）', with: 'password'
        check '管理者権限'
        click_button '登録する'
        expect(page).to have_content '新規管理者'
        expect(page).to have_content 'ユーザを登録しました'
      end

      it 'ユーザ詳細画面にアクセスできる' do
        visit admin_user_path(user)
        expect(page).to have_content user.name
        expect(page).to have_content user.email
      end

      it 'ユーザ編集画面から、自分以外のユーザを編集できる' do
        visit edit_admin_user_path(user)
        fill_in '名前', with: '編集ユーザ'
        click_button '更新する'
        expect(page).to have_content '編集ユーザ'
        expect(page).to have_content 'ユーザを更新しました'
      end

      it 'ユーザを削除できる' do
        visit admin_users_path
        click_link '削除', match: :first
        expect(page).not_to have_content user.name
        expect(page).to have_content 'ユーザを削除しました'
      end
    end

    context '一般ユーザがユーザ一覧画面にアクセスした場合' do
      before do
        visit new_session_path
        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード', with: user.password
        click_button 'ログインする'
      end

      it 'タスク一覧画面に遷移し、「管理者以外アクセスできません」というエラーメッセージが表示される' do
        visit admin_users_path
        expect(page).to have_content '管理者以外アクセスできません'
        expect(page).to have_content 'タスク一覧'
      end
    end
  end
end
