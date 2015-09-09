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
    #     { name: 'foo', multiple_type: true,  namespace: 'dc', datastream: 'DC.1'},  
    #     { name: 'bar', multiple_type: false, namespace: 'dc', datastream: 'DC.1'} 
    #   ]
    #
    def properties
      @properties ||= build_properties
    end
    
    # Collects object properties
    # 
    #   <foxml:objectProperties>
    #     <foxml:property NAME="foo#bar" VALUE="2014-02-05T00:31:44.421Z"/>
    #     <foxml:extproperty NAME="http://example.com#type" VALUE="FedoraObject"/>
    #   </foxml:objectProperties>
    #   
    #   Will produce
    #   
    #     [
    #       { name: 'foo#bar', value: '2014-02-05T00:31:44.421Z', external: false },
    #       { name: 'http://example.com#type', value: 'FedoraObject', external: true}
    #     ]
    #
    def object_properties
      @object_properties ||= build_object_properties
    end
    
    # Identifies which object type the item is a member of
    def is_member_of
      return unless namespaces.keys.include? :rdf
      @is_member_of ||= is_member_of_element.to_s.split(':').last
    end
    
    # TODO - replace data_streams with datastreams
    def data_streams
      datastreams.select{|k,| /^DC/ =~ k }
    end
    
    def datastreams
      @datastreams ||= xml_content_nodes.inject(empty_hash) do |hash, node|
        name = node.parent.attribute('ID').value
        hash[name] = get_namespace_for(node)
        hash
      end
    end
    
    def doc
      @doc ||= Nokogiri::XML xml
    end
    
    # A hash of namespaces with name keys and the uri's where they are defined
    # as values. This is built from the document itself using 
    #   Nokogiri::XML::Document#collect_namespaces
    def namespaces
      @namespaces ||= doc.collect_namespaces.inject({}) do |hash, namespace| 
        name, uri = namespace
        name = remove_leading_xmlns(name)
        hash[name.to_sym] = uri
        hash
      end
    end
    
    private    
    
    # Furthest nodes are the children within a node, that do not have children
    # So for:
    #   <x>
    #     <y>
    #       <z></z>
    #     </y>
    #   </x>
    # 
    # The furthest node for x would be z
    #
    def furthest_nodes_for(node)
      if node.children.empty? 
        node
      else
        # this node not an end point so move on to children of this node
        children = node.children.collect{|n| furthest_nodes_for n}.flatten
        # remove empty text elements
        children.select do |c| 
          c.class == Nokogiri::XML::Element || 
            (c.class == Nokogiri::XML::Text && c.content.present?)
        end
      end
    end
    
    # We are using names spaces to retrieve data in the furthest nodes,
    # so need the name spaces that apply to those nodes.
    def get_namespace_for(node)
      further_node_namespaces = furthest_nodes_for(node).collect do |n| 
        n.namespace ? n.namespace.prefix : n.parent.namespace.prefix
      end
      further_node_namespaces.first
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
    
    def build_object_properties
      object_property_nodes.collect do |node|
        empty_hash(
          external: (node.name == 'extproperty'),
          name: node.attributes['NAME'].value,
          value: node.attributes['VALUE'].value
        )
      end
    end
    
    def object_property_nodes
      nodes = doc.xpath("//foxml:objectProperties", namespaces).children
      nodes.select{|o| o.class == Nokogiri::XML::Element}
    end
    
    def is_member_of_element
      doc.xpath(
        '//foxml:datastream[@ID="RELS-EXT"]//rel:isMemberOf/@rdf:resource',
        namespaces
      )
    end
    
    # The xmlContent nodes are a useful point to extract data. 
    #   * parents are the datastreamVersion elements, so can identify datastreams
    #   * childrent can be used to identify the namespace being used within
    #     the datastream
    def xml_content_nodes
      @xml_content_nodes ||= doc.xpath("//foxml:xmlContent", namespaces)
    end
    
    def remove_leading_xmlns(name)
      name.sub(/^xmlns:/, '')
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
