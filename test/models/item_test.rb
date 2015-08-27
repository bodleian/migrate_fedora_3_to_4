require 'test_helper'

class ItemTest < ActiveSupport::TestCase
  
  def test_populate
    assert_difference 'Item.count', id_list_json_valid_id_count do
      Item.populate id_list_json
    end
    object_id = Item.last
    assert_equal 'uuid:397e625f-9492-4f4a-8fa5-a41a53cf80f7', object_id.identifier
  end
  
  def test_running_populate_twice_does_not_create_duplicates
    test_populate
    assert_no_difference 'Item.count' do
      Item.populate id_list_json
    end
  end
  
  def test_object_model_name
    assert_equal item.object_model.name, item.object_model_name
  end
  
  def item
    items(:one)
  end
  
end
