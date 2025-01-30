require 'rails_helper'

RSpec.describe 'ラベル管理機能', type: :system do
  let!(:user) { FactoryBot.create(:user) }

  
  describe '登録機能' do
    context 'ラベルを登録した場合' do
      it '登録したラベルが表示される' do

        visit new_session_path
        fill_in 'session_email', with: user.email
        fill_in 'session_password', with: user.password
        click_button 'ログイン'

        visit new_label_path
        fill_in 'label[name]', with: '新しいラベル'
        click_button '登録する'
        expect(page).to have_content '新しいラベル'
      end
    end
  end

  describe '一覧表示機能' do
    context '一覧画面に遷移した場合' do
      it '登録済みのラベル一覧が表示される' do

        visit new_session_path
        fill_in 'session_email', with: user.email
        fill_in 'session_password', with: user.password
        click_button 'ログイン'
        
        FactoryBot.create(:label, name: 'ラベル１', user: user)
        FactoryBot.create(:label, name: 'ラベル２', user: user)
        visit labels_path
        expect(page).to have_content 'ラベル１'
        expect(page).to have_content 'ラベル２'
      end
    end
  end
end