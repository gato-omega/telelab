require 'test_helper'

class PortsControllerTest < ActionController::TestCase
  setup do
    @port = ports(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:ports)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create port" do
    assert_difference('Port.count') do
      post :create, :port => @port.attributes
    end

    assert_redirected_to port_path(assigns(:port))
  end

  test "should show port" do
    get :show, :id => @port.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @port.to_param
    assert_response :success
  end

  test "should update port" do
    put :update, :id => @port.to_param, :port => @port.attributes
    assert_redirected_to port_path(assigns(:port))
  end

  test "should destroy port" do
    assert_difference('Port.count', -1) do
      delete :destroy, :id => @port.to_param
    end

    assert_redirected_to ports_path
  end
end
