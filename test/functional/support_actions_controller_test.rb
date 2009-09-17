require 'test_helper'

class SupportActionsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:support_actions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create support_action" do
    assert_difference('SupportAction.count') do
      post :create, :support_action => { }
    end

    assert_redirected_to support_action_path(assigns(:support_action))
  end

  test "should show support_action" do
    get :show, :id => support_actions(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => support_actions(:one).id
    assert_response :success
  end

  test "should update support_action" do
    put :update, :id => support_actions(:one).id, :support_action => { }
    assert_redirected_to support_action_path(assigns(:support_action))
  end

  test "should destroy support_action" do
    assert_difference('SupportAction.count', -1) do
      delete :destroy, :id => support_actions(:one).id
    end

    assert_redirected_to support_actions_path
  end
end
