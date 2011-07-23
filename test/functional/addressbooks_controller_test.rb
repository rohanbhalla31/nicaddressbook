require 'test_helper'

class AddressbooksControllerTest < ActionController::TestCase
  setup do
    @addressbook = addressbooks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:addressbooks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create addressbook" do
    assert_difference('Addressbook.count') do
      post :create, :addressbook => @addressbook.attributes
    end

    assert_redirected_to addressbook_path(assigns(:addressbook))
  end

  test "should show addressbook" do
    get :show, :id => @addressbook.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @addressbook.to_param
    assert_response :success
  end

  test "should update addressbook" do
    put :update, :id => @addressbook.to_param, :addressbook => @addressbook.attributes
    assert_redirected_to addressbook_path(assigns(:addressbook))
  end

  test "should destroy addressbook" do
    assert_difference('Addressbook.count', -1) do
      delete :destroy, :id => @addressbook.to_param
    end

    assert_redirected_to addressbooks_path
  end
end
