require 'test_helper'

class PuertosControllerTest < ActionController::TestCase
  setup do
    @puerto = puertos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:puertos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create puerto" do
    assert_difference('Puerto.count') do
      post :create, :puerto => @puerto.attributes
    end

    assert_redirected_to puerto_path(assigns(:puerto))
  end

  test "should show puerto" do
    get :show, :id => @puerto.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @puerto.to_param
    assert_response :success
  end

  test "should update puerto" do
    put :update, :id => @puerto.to_param, :puerto => @puerto.attributes
    assert_redirected_to puerto_path(assigns(:puerto))
  end

  test "should destroy puerto" do
    assert_difference('Puerto.count', -1) do
      delete :destroy, :id => @puerto.to_param
    end

    assert_redirected_to puertos_path
  end
end
