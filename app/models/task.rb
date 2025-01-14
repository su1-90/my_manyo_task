class Task < ApplicationRecord
  validates :title, presence: { message: I18n.t('errors.messages.blank_no_attribute') }
  validates :content, presence: { message: I18n.t('errors.messages.blank_no_attribute') }
  validates :deadline_on, presence: { message: I18n.t('errors.messages.deadline_on_blank') }
  validates :priority, presence: { message: I18n.t('errors.messages.priority_blank') }
  validates :status, presence: { message: I18n.t('errors.messages.status_blank') }

  paginates_per 10

  enum priority: { low: 0, medium: 1, high: 2 }, _prefix: true
  enum status: { not_started: 0, in_progress: 1, completed: 2 }, _prefix: true

  scope :sorted_by_creation, -> { order(created_at: :desc) }
  scope :sorted_by_deadline, -> { order(deadline_on: :asc) }
  scope :sorted_by_priority, -> { order(priority: :desc) }

  scope :search_by_title, -> (title) { where("title LIKE ?", "%#{title}%") }
  scope :search_by_status, -> (status) { where(status: status) }
  scope :search_by_title_and_status, -> (title, status) {
    search_by_title(title).search_by_status(status)
  } 
end
