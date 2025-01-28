class Label < ApplicationRecord
  belongs_to :user
  has_many :labelings
  has_many :tasks, through: :labelings

  validates :name, presence: { message: "名前を入力してください" }
end
