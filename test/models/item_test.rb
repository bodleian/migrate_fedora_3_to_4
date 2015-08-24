require 'test_helper'

class ItemTest < ActiveSupport::TestCase
  
  def test_populate
    Item.delete_all
    Item.populate id_list_json
    assert_equal id_list_json_valid_id_count, Item.count
    object_id = Item.first
    assert_equal 'uuid:7696fb2e-b4fc-496f-a0aa-dedccc6ab062', object_id.identifier
  end
  
  def test_running_populate_twice_does_not_create_duplicates
    test_populate
    Item.populate id_list_json
    assert_equal 146, Item.count
  end
  
end
