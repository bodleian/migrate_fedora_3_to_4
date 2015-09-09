# Manages the process of populating an item with information defined in
# the fedora details XML for that object
module Process
  class ItemPopulator
    
    PROCESS_STEPS = [
      :add_property_values,
      :add_properties,
      :add_object_properties,
      :record_source_url,
      :add_external_datastreams    
    ]
    
    # Typical usage:
    #   ItemPopulator.for(
    #     item,
    #     fedora_root: 'http://localhost:8080/fedora,
    #     username: 'fedoraAdmin',
    #     password: 'password'
    #   )
    #
    # This will gather the XML describing this item, from fedora. Then the data
    # contained in the XML will be used to update the item and create
    # sub-objects (for example, properties and propery_values) where this
    # data is stored.
    #
    def self.for item, args
      item_populator = new(item, args)
      item_populator.run_process_steps
      item.save
      item_populator
    end
        
    attr_reader :item, :args
    
    def initialize(item, args)
      @item = item
      @args = args
    end
    
    def run_process_steps
      PROCESS_STEPS.each{|process_step| send process_step }
    end
    
    def assign_to_object_model
      item.object_model = object_model
    end
    
    def add_property_values
      item.property_values.destroy_all
      item_data.property_values.each do |params|
        item.property_values.create(params)
      end
    end
    
    def add_properties
      assign_to_object_model
      item_data.properties.each do |args|
        property = object_model.properties.find_or_initialize_by(
                                            name: args[:name], 
                                            datastream: args[:datastream],
                                            namespace: args[:namespace]
                                          )
        property.multiple_type = args[:multiple_type]
        property.save
      end
    end
    
    def add_object_properties
      item_data.object_properties.each do |params|
        object_property = item.object_properties.find_or_initialize_by name: params[:name]
        object_property.value = params[:value]
        object_property.external = params[:external]
        object_property.save
      end
    end
    
    def add_external_datastreams
      item.external_datastreams = item_data.external_datastreams
    end
    
    def record_source_url
      item.source_url = item_xml_connector.path_for item.identifier
    end
    
    def object_model
      @object_model ||= ObjectModel.find_or_create_by(name: object_model_name)
    end
    
    def object_model_name
      item_data.is_member_of || ObjectModel::UNKNOWN
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
