require 'rails_helper'

RSpec.describe 'ユーザ管理機能', type: :system do
  describe '登録機能' do
    let!(:user) { FactoryBot.create(:user) }

    context 'ユーザを登録した場合' do
      it 'タスク一覧画面に遷移する' do
        visit new_user_path
        fill_in 'user[name]', with: '新規ユーザ'
        fill_in 'user[email]', with: 'new@example.com'
        fill_in 'user[password]', with: 'password'
        fill_in 'user[password_confirmation]', with: 'password'
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
    let!(:user) { FactoryBot.create(:user) }
    let!(:admin_user) { FactoryBot.create(:admin_user) }

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
    let!(:admin_user) { FactoryBot.create(:admin_user) }
    let!(:user) { FactoryBot.create(:user) }
    let!(:other_user) { FactoryBot.create(:user, name: '削除対象ユーザー', email: 'delete_me@example.com') }

    context '管理者がログインした場合' do
      before do
        visit new_session_path
        fill_in 'email', with: admin_user.email
        fill_in 'password', with: admin_user.password
        click_button 'ログイン'
      end

      it 'ユーザ一覧画面にアクセスできる' do
        visit admin_users_path
        expect(page).to have_content 'ユーザ一覧'
      end

      it '管理者を登録できる' do
        visit new_admin_user_path
        fill_in 'user[name]', with: '新規管理者'
        fill_in 'user[email]', with: 'new_admin@example.com'
        fill_in 'user[password]', with: 'password'
        fill_in 'user[password_confirmation]', with: 'password'
        check 'user[admin]'
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
        fill_in 'user[name]', with: '編集ユーザ'
        fill_in 'user[password]', with: 'password'
        fill_in 'user[password_confirmation]', with: 'password'
        click_button '更新する'
        expect(page).to have_content '編集ユーザ'
        expect(page).to have_content 'ユーザを更新しました'
      end

      it 'ユーザを削除できる' do
        visit admin_users_path
        link_xpath = "//tr[td[contains(text(), '削除対象ユーザー')]]//a[contains(@class, 'destroy-user')]"
        puts "削除リンク: #{link_xpath}"
      
        accept_confirm do
          find(:xpath, link_xpath).click
        end
      
        expect(page).to have_content 'ユーザを削除しました'
        
        expect(page).not_to have_content '削除対象ユーザー'
      
        deleted_user = User.find_by(name: '削除対象ユーザー')
        expect(deleted_user).to be_nil
      end
    end

    context '一般ユーザがユーザ一覧画面にアクセスした場合' do
      before do
        visit new_session_path
        fill_in 'email', with: user.email
        fill_in 'password', with: user.password
        click_button 'ログイン'
      end

      it 'タスク一覧画面に遷移し、「管理者以外アクセスできません」というエラーメッセージが表示される' do
        visit admin_users_path
        expect(page).to have_content '管理者以外アクセスできません'
        expect(page).to have_content 'タスク一覧'
      end
    end
  end
end
