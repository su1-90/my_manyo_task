class Task < ApplicationRecord
  validates :title, presence: { message: I18n.t('errors.messages.blank') }
  validates :content, presence: { message: I18n.t('errors.messages.blank') }
end
