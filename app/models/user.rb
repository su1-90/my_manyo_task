class User < ApplicationRecord
  has_secure_password

  validates :name, presence: { message: "名前を入力してください" }
  validates :email, presence: { message: "メールアドレスを入力してください" }, uniqueness: { case_sensitive: false, message: "メールアドレスはすでに使用されています" }
  validates :password, presence: { message: "パスワードを入力してください" }, length: { minimum: 6, message: "パスワードは6文字以上で入力してください" }, confirmation: { message: "パスワード（確認）とパスワードの入力が一致しません" }

  has_many :tasks, dependent: :destroy

  before_save :downcase_email

  private

  def downcase_email
    self.email = email.downcase
  end
end
