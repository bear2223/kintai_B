# frozen_string_literal: true

require 'test_helper'

# jhk
class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test 'should get top' do
    get static_pages_top_url
    assert_response :success
  end
end
