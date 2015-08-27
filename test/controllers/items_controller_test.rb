require 'test_helper'

class ItemsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_response :success
    assert_equal Item.all, assigns('items')
  end

  def test_show
    get :show, id: item
    assert_response :success
    assert_equal item, assigns('item')
  end
  
  def item
    @item ||= items(:one)
  end

end
