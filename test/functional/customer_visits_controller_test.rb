require 'test_helper'

class CustomerVisitsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:customer_visits)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create customer_visit" do
    assert_difference('CustomerVisit.count') do
      post :create, :customer_visit => { }
    end

    assert_redirected_to customer_visit_path(assigns(:customer_visit))
  end

  test "should show customer_visit" do
    get :show, :id => customer_visits(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => customer_visits(:one).id
    assert_response :success
  end

  test "should update customer_visit" do
    put :update, :id => customer_visits(:one).id, :customer_visit => { }
    assert_redirected_to customer_visit_path(assigns(:customer_visit))
  end

  test "should destroy customer_visit" do
    assert_difference('CustomerVisit.count', -1) do
      delete :destroy, :id => customer_visits(:one).id
    end

    assert_redirected_to customer_visits_path
  end
end
