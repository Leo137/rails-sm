require 'test_helper'

class StairwaysControllerTest < ActionController::TestCase
  setup do
    @stairway = stairways(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:stairways)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create stairway" do
    assert_difference('Stairway.count') do
      post :create, stairway: { name: @stairway.name, user_id: @stairway.user_id }
    end

    assert_redirected_to stairway_path(assigns(:stairway))
  end

  test "should show stairway" do
    get :show, id: @stairway
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @stairway
    assert_response :success
  end

  test "should update stairway" do
    patch :update, id: @stairway, stairway: { name: @stairway.name, user_id: @stairway.user_id }
    assert_redirected_to stairway_path(assigns(:stairway))
  end

  test "should destroy stairway" do
    assert_difference('Stairway.count', -1) do
      delete :destroy, id: @stairway
    end

    assert_redirected_to stairways_path
  end
end
