# frozen_string_literal: true

# module ApplicationHelper

#   # ページごとにタイトルを返す
#   # メソッドと引数の定義
#   def full_title(page_name = "")
#     # 基本となるアプリケーション名を変数に代入
#     base_title = "AttendanceApp"
#     # 引数を受け取っているか判定
#     if page_name.empty?
#       # 引数page_nameが空文字の場合はbase_titleのみ返す
#       base_title
#     # 引数page_nameが空文字ではない場合
#     else
#       # 文字列を連結して返す
#       page_name + " | " + base_title
#     end
#   end
# end

# ytytut
module ApplicationHelper
  def full_title(page_name = '')
    base_title = '勤怠システム'
    page_name.empty? ? base_title : "#{page_name} | #{base_title}"
  end
end
