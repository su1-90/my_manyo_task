class User < ApplicationRecord
  has_secure_password

  before_destroy :ensure_an_admin_remains
  before_update :ensure_an_admin_remains_if_admin_changed

  validates :name, presence: { message: "名前を入力してください" }
  validates :email, presence: { message: "メールアドレスを入力してください" }, uniqueness: { case_sensitive: false, message: "メールアドレスはすでに使用されています" }
  validates :password, presence: { message: "パスワードを入力してください" }, length: { minimum: 6, message: "パスワードは6文字以上で入力してください" }, confirmation: { message: "パスワード（確認）とパスワードの入力が一致しません" }

  has_many :tasks, dependent: :destroy

  before_save :downcase_email
  
  def downcase_email
    self.email = email.downcase
  end
  
  private

  def ensure_an_admin_remains
    if User.where(admin: true).count == 1 && self.admin?
      errors.add(:base, "管理者が0人になるため削除できません")
      throw(:abort)
    end
  end

  def ensure_an_admin_remains_if_admin_changed
    if self.admin_was && self.admin_changed? && !self.admin && User.where(admin: true).count == 1
      errors.add(:base, "管理者が0人になるため権限を変更できません")
      throw(:abort)
    end
  end
end