# frozen_string_literal: true

# hg
class Attendance < ApplicationRecord
  belongs_to :user

  validates :worked_on, presence: true
  validates :note, length: { maximum: 50 }

  # 出勤時間が存在しない場合、退勤時間は無効
  validate :finished_at_is_invalid_without_a_started_at
  # 出勤・退勤時間どちらも存在する時、出勤時間より早い退勤時間は無効
  validate :started_at_than_finished_at_fast_if_invalid
  # jhjhkjhk
  validate :only_started_at_or_only_finished_at_is_invalid, on: :editt

  def finished_at_is_invalid_without_a_started_at
    errors.add(:started_at, 'が必要です') if started_at.blank? && finished_at.present?
  end

  def started_at_than_finished_at_fast_if_invalid
    return unless started_at.present? && finished_at.present?

    errors.add(:started_at, 'より早い退勤時間は無効です') if started_at > finished_at
  end

  def only_started_at_or_only_finished_at_is_invalid
    if started_at_changed? && !finished_at_changed?
      errors.add(:finished_at, 'と出勤時間を入力してください。')
    elsif finished_at_changed? && !started_at_changed?
      errors.add(:started_at, 'と退勤時間を入力してください。')
    end
  end
end
