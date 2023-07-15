# frozen_string_literal: true

# gjgjh
module AttendancesHelper
  def attendance_state(attendance)
    return unless Date.current == attendance.worked_on

    if attendance.started_at.nil?
      '出勤'
    elsif attendance.finished_at.nil?
      '退勤'
    end
  end

  def working_times(start, finish)
    format('%.2f', (((finish - start) / 60) / 60.0))
  end
end
