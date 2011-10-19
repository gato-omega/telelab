require 'test_helper'

class DeviceConnectionsControllerTest < ActionController::TestCase
  setup do
    @device_connection = device_connections(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:device_connections)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create device_connection" do
    assert_difference('DeviceConnection.count') do
      post :create, :device_connection => @device_connection.attributes
    end

    assert_redirected_to device_connection_path(assigns(:device_connection))
  end

  test "should show device_connection" do
    get :show, :id => @device_connection.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @device_connection.to_param
    assert_response :success
  end

  test "should update device_connection" do
    put :update, :id => @device_connection.to_param, :device_connection => @device_connection.attributes
    assert_redirected_to device_connection_path(assigns(:device_connection))
  end

  test "should destroy device_connection" do
    assert_difference('DeviceConnection.count', -1) do
      delete :destroy, :id => @device_connection.to_param
    end

    assert_redirected_to device_connections_path
  end
end
