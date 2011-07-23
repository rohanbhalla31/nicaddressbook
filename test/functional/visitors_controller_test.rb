require 'test_helper'

class VisitorsControllerTest < ActionController::TestCase
  setup do
    @visitor = visitors(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:visitors)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create visitor" do
    assert_difference('Visitor.count') do
      post :create, :visitor => @visitor.attributes
    end

    assert_redirected_to visitor_path(assigns(:visitor))
  end

  test "should show visitor" do
    get :show, :id => @visitor.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @visitor.to_param
    assert_response :success
  end

  test "should update visitor" do
    put :update, :id => @visitor.to_param, :visitor => @visitor.attributes
    assert_redirected_to visitor_path(assigns(:visitor))
  end

  test "should destroy visitor" do
    assert_difference('Visitor.count', -1) do
      delete :destroy, :id => @visitor.to_param
    end

    assert_redirected_to visitors_path
  end
end
