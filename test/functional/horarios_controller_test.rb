require 'test_helper'

class HorariosControllerTest < ActionController::TestCase
  setup do
    @horario = horarios(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:horarios)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create horario" do
    assert_difference('Horario.count') do
      post :create, :horario => @horario.attributes
    end

    assert_redirected_to horario_path(assigns(:horario))
  end

  test "should show horario" do
    get :show, :id => @horario.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @horario.to_param
    assert_response :success
  end

  test "should update horario" do
    put :update, :id => @horario.to_param, :horario => @horario.attributes
    assert_redirected_to horario_path(assigns(:horario))
  end

  test "should destroy horario" do
    assert_difference('Horario.count', -1) do
      delete :destroy, :id => @horario.to_param
    end

    assert_redirected_to horarios_path
  end
end
