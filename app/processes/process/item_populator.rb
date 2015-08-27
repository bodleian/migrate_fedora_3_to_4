
module Process
  class ItemPopulator
    
    def self.do_for item, args
      item_populator = new(item, args)
      item_populator.assign_property_values
      item_populator.add_properties
      item_populator
    end
    
    attr_reader :item, :args
    
    def initialize(item, args)
      @item = item
      @args = args
    end
    
    def assign_to_object_model
      item.object_model = object_model
    end
    
    def assign_property_values
      item.property_values.destroy_all
      item_data.property_values.each do |name, value|
        item.property_values.create(name: name, value: value)
      end
    end
    
    def add_properties
      assign_to_object_model
      item_data.properties.each do |name, multiple_type|
        object_model.properties.create(name: name, multiple_type: multiple_type)
      end
    end
    
    def object_model
      @object_model ||= ObjectModel.find_or_create_by(name: item_data.is_member_of)
    end
    
    def item_data
      @item_data ||= Converter::XmlToItem.new item_xml
    end
    
    def item_xml
      item_xml_connector.get_xml_for item.identifier
    end
    
    def item_xml_connector
      @item_xml_connector ||= Connector::ItemXml.new(args)
    end
    
  end
end
