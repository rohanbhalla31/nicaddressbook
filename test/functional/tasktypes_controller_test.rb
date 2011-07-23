require 'test_helper'

class TasktypesControllerTest < ActionController::TestCase
  setup do
    @tasktype = tasktypes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tasktypes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tasktype" do
    assert_difference('Tasktype.count') do
      post :create, :tasktype => @tasktype.attributes
    end

    assert_redirected_to tasktype_path(assigns(:tasktype))
  end

  test "should show tasktype" do
    get :show, :id => @tasktype.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @tasktype.to_param
    assert_response :success
  end

  test "should update tasktype" do
    put :update, :id => @tasktype.to_param, :tasktype => @tasktype.attributes
    assert_redirected_to tasktype_path(assigns(:tasktype))
  end

  test "should destroy tasktype" do
    assert_difference('Tasktype.count', -1) do
      delete :destroy, :id => @tasktype.to_param
    end

    assert_redirected_to tasktypes_path
  end
end
