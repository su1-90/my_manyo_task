require 'rails_helper'

RSpec.describe 'ラベルモデル機能', type: :model do
  describe 'バリデーションのテスト' do
    let(:user) { User.create(name: 'Test User', email: 'label-test@example.com', password: 'password') }

    context 'ラベルの名前が空文字の場合' do
      it 'バリデーションに失敗する' do
        label = Label.new(name: '', user: user)
        expect(label).not_to be_valid
      end
    end

    context 'ラベルの名前に値があった場合' do
      it 'バリデーションに成功する' do
        label = Label.new(name: 'Sample Label', user: user)
        expect(label).to be_valid
      end
    end
  end
end