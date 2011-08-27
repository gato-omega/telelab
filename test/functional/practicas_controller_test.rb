require 'test_helper'

class PracticasControllerTest < ActionController::TestCase
  setup do
    @practica = practicas(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:practicas)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create practica" do
    assert_difference('Practica.count') do
      post :create, :practica => @practica.attributes
    end

    assert_redirected_to practica_path(assigns(:practica))
  end

  test "should show practica" do
    get :show, :id => @practica.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @practica.to_param
    assert_response :success
  end

  test "should update practica" do
    put :update, :id => @practica.to_param, :practica => @practica.attributes
    assert_redirected_to practica_path(assigns(:practica))
  end

  test "should destroy practica" do
    assert_difference('Practica.count', -1) do
      delete :destroy, :id => @practica.to_param
    end

    assert_redirected_to practicas_path
  end
end
