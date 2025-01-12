class Task < ApplicationRecord
  validates :title, presence: { message: I18n.t('errors.messages.blank_no_attribute') }
  validates :content, presence: { message: I18n.t('errors.messages.blank_no_attribute') }
  validates :deadline_on, presence: { message: I18n.t('errors.messages.deadline_on_blank') }
  validates :priority, presence: { message: I18n.t('errors.messages.priority_blank') }
  validates :status, presence: { message: I18n.t('errors.messages.status_blank') }

  paginates_per 10

  enum priority: { low: 0, medium: 1, high: 2 }, _prefix: true
  enum status: { not_started: 0, in_progress: 1, completed: 2 }, _prefix: true
end
