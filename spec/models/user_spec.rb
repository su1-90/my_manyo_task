require 'rails_helper'

RSpec.describe 'ユーザモデル機能', type: :model do
  describe 'バリデーションのテスト' do
    context 'ユーザの名前が空文字の場合' do
      it 'バリデーションに失敗する' do
        user = User.new(name: '', email: 'test@example.com', password: 'password')
        expect(user).not_to be_valid
        expect(user.errors[:name]).to include('名前を入力してください')
      end
    end

    context 'ユーザのメールアドレスが空文字の場合' do
      it 'バリデーションに失敗する' do
        user = User.new(name: 'Test User', email: '', password: 'password')
        expect(user).not_to be_valid
        expect(user.errors[:email]).to include('メールアドレスを入力してください')
      end
    end

    context 'ユーザのパスワードが空文字の場合' do
      it 'バリデーションに失敗する' do
        user = User.new(name: 'Test User', email: 'test@example.com', password: '')
        expect(user).not_to be_valid
        expect(user.errors[:password]).to include('パスワードを入力してください')
      end
    end

    context 'ユーザのメールアドレスがすでに使用されていた場合' do
      before do
        User.create(name: 'Existing User', email: 'existing@example.com', password: 'password')
      end

      it 'バリデーションに失敗する' do
        user = User.new(name: 'Test User', email: 'existing@example.com', password: 'password')
        expect(user).not_to be_valid
        expect(user.errors[:email]).to include('メールアドレスはすでに使用されています')
      end
    end

    context 'ユーザのパスワードが6文字未満の場合' do
      it 'バリデーションに失敗する' do
        user = User.new(name: 'Test User', email: 'test@example.com', password: 'short')
        expect(user).not_to be_valid
        expect(user.errors[:password]).to include('パスワードは6文字以上で入力してください')
      end
    end

    context 'ユーザの名前に値があり、メールアドレスが使われていない値で、かつパスワードが6文字以上の場合' do
      it 'バリデーションに成功する' do
        user = User.new(name: 'Test User', email: 'valid@example.com', password: 'password')
        expect(user).to be_valid
      end
    end
  end
end
