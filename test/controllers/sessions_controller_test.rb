# frozen_string_literal: true

require 'test_helper'

# hhf
class SessionsControllerTest < ActionDispatch::IntegrationTest
  test 'should get new' do
    get sessions_new_url
    assert_response :success
  end
end
