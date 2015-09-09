require 'test_helper'

class ItemsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_response :success
    assert_equal Item.order(:identifier).page, assigns('items')
  end
  
  def test_index_with_object_model
    get :index, object_model_id: object_model
    assert_response :success
    assert_equal object_model.items.order(:identifier).page, assigns('items')
  end

  def test_show
    get :show, id: item
    assert_response :success
    assert_equal item, assigns('item')
  end
  
  def item
    @item ||= items(:one)
  end
  
  def object_model
    @object_model ||= object_models(:foo)
  end

end
