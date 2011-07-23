require 'test_helper'

class FileuploadsControllerTest < ActionController::TestCase
  setup do
    @fileupload = fileuploads(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:fileuploads)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create fileupload" do
    assert_difference('Fileupload.count') do
      post :create, :fileupload => @fileupload.attributes
    end

    assert_redirected_to fileupload_path(assigns(:fileupload))
  end

  test "should show fileupload" do
    get :show, :id => @fileupload.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @fileupload.to_param
    assert_response :success
  end

  test "should update fileupload" do
    put :update, :id => @fileupload.to_param, :fileupload => @fileupload.attributes
    assert_redirected_to fileupload_path(assigns(:fileupload))
  end

  test "should destroy fileupload" do
    assert_difference('Fileupload.count', -1) do
      delete :destroy, :id => @fileupload.to_param
    end

    assert_redirected_to fileuploads_path
  end
end
