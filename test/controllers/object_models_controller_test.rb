require 'test_helper'

class ObjectModelsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_equal ObjectModel.all, assigns('object_models')
  end

  test "should get show" do
    get :show, id: object_model
    assert_response :success
    assert_equal object_model, assigns('object_model')
  end
  
  def object_model
    @object_model ||= object_models(:foo)
  end

end
