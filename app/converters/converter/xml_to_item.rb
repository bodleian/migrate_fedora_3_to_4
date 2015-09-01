# Extracts data from the XML that describes an item.
module Converter
  class XmlToItem
    
    attr_reader :xml
    
    def initialize(xml)
      @xml = xml     
    end
    
    # Collects all the item's properties in a parameters hash.
    # Note that names will not be unique. That is, as a property may have multiple
    # values, each value will result in an individual property_value. So:
    # 
    #   <foxml:datastreamVersion ID="DC.1">
    #     <dc:foo>x</dc:foo><dc:foo>y</dc:foo><dc:bar>z</dc:bar>
    #   </foxml:datastreamVersion>
    #   
    # Will produce:
    # 
    #   [
    #     { name: 'foo', value: 'x', namespace: 'dc', datastream: 'DC.1'}, 
    #     { name: 'foo', value: 'y', namespace: 'dc', datastream: 'DC.1'}, 
    #     { name: 'bar', value: 'z', namespace: 'dc', datastream: 'DC.1'} 
    #   ]
    #
    def property_values
      @property_values ||= build_property_values.flatten
    end
    
    # Identifies all the property fields used in the item together with whether
    # they are used singularly or multiple times. Thus:
    # 
    #   <foxml:datastreamVersion ID="DC.1">
    #     <dc:foo>x</dc:foo><dc:foo>y</dc:foo><dc:bar>z</dc:bar>
    #   </foxml:datastreamVersion>
    #   
    # Will produce:
    # 
    #   [
    #     { name: 'foo', multiple_type: true, namespace: 'dc', datastream: 'DC.1'},  
    #     { name: 'bar', multiple_type: false, namespace: 'dc', datastream: 'DC.1'} 
    #   ]
    #
    def properties
      @properties ||= build_properties
    end
    
    # Identifies which object type the item is a member of
    def is_member_of
      @is_member_of ||= is_member_of_element.to_s.split(':').last
    end
    
    def data_streams
      {
        'DC.1' => 'dc',
        'DC1.0' => 'dc'
      }
    end
    
    private
    def raw_dc_elements
      @raw_dc_elements ||= doc.xpath(
        '//foxml:datastreamVersion[@ID="DC.1"]//dc:*',
        namespaces
      )
    end
    
    def build_properties
      properties = empty_hash
      data_streams.keys.each do |datastream|
        namespace = data_streams[datastream]
        raw_dc_elements_for(datastream, namespace).each do |element| 
          name = [datastream.to_s, element.name].join(':')
          if property_seen_before?(datastream, element.name)
            properties[name][:multiple_type] = true
          else
            properties[name] = empty_hash(
              name: element.name, 
              multiple_type: false,
              namespace: namespace,
              datastream: datastream
            )
          end
        end
      end
      properties.values
    end
    
    def build_property_values
      data_streams.keys.collect do |datastream|
        namespace = data_streams[datastream]
        raw_dc_elements_for(datastream, namespace).collect do |e| 
          empty_hash(
            name: e.name, 
            value: e.text,
            namespace: namespace,
            datastream: datastream
          )
        end
      end
    end
    
    def raw_dc_elements_for(datastream, namespace)
      doc.xpath(
        "//foxml:datastreamVersion[@ID=\"#{datastream}\"]//#{namespace}:*",
        namespaces
      )
    end
    
    def is_member_of_element
      doc.xpath(
        '//foxml:datastream[@ID="RELS-EXT"]//rel:isMemberOf/@rdf:resource',
        namespaces
      )
    end
    
    def doc
      @doc ||= Nokogiri::XML xml
    end
    
    def namespaces
      {
        foxml: 'info:fedora/fedora-system:def/foxml#', 
        dc: 'http://purl.org/dc/elements/1.1/',
        rel: 'info:fedora/fedora-system:def/relations-external#', 
        rdf: 'http://www.w3.org/1999/02/22-rdf-syntax-ns#'
      }
    end
    
    def empty_hash(args = {})
      HashWithIndifferentAccess.new args
    end
    
    def property_seen_before?(datastream, name)
      name = name.to_sym
      @property_seen_before ||= empty_hash
      @property_seen_before[datastream] ||= []
      if @property_seen_before[datastream].include? name
        return true
      else
        @property_seen_before[datastream] << name
        return false
      end
    end

  end
end
