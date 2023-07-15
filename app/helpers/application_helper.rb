# frozen_string_literal: true

# ytytut
module ApplicationHelper
  def full_title(page_name = '')
    base_title = '勤怠システム'
    page_name.empty? ? base_title : "#{page_name} | #{base_title}"
  end
end
