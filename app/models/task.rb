class Task < ApplicationRecord
  validates :title, presence: { message: I18n.t('errors.messages.blank') }
  validates :content, presence: { message: I18n.t('errors.messages.blank') }

  paginates_per 10

  enum priority: { low: 0, medium: 1, high: 2 }, _prefix: true
  enum status: { not_started: 0, in_progress: 1, completed: 2 }, _prefix: true
end
