# Extracts data from the XML that describes an item.
module Converter
  class XmlToItem
    
    attr_reader :xml
    
    def initialize(xml)
      @xml = xml     
    end
    
    # Collects all the item's properties in an array of property name/value pairs
    # Note that names will not be unique. That is, as a property may have multiple
    # values, each value will result in a property name/value pair. So:
    # 
    #   <dc:foo>x</dc:foo><dc:foo>y</dc:foo><dc:bar>z</dc:bar>
    #   
    # Will produce:
    # 
    #   [
    #     { name: 'foo', value: 'x', namespace: 'dc'}, 
    #     { name: 'foo', value: 'y', namespace: 'dc'}, 
    #     { name: 'bar', value: 'z', namespace: 'dc'} 
    #   ]
    #
    def property_values
      @property_values ||= raw_dc_elements.collect do|e| 
        {
          name: e.name, 
          value: e.text,
          namespace: 'dc'
        }
      end
    end
    
    # Identifies all the property fields used in the item together with whether
    # they are used singularly or multiple times. Thus:
    # 
    #   <dc:foo>x</dc:foo><dc:foo>y</dc:foo><dc:bar>z</dc:bar>
    #   
    # Will produce:
    # 
    #   {'foo' => 'multi', 'bar' => 'single'}
    #
    def properties
      @properties ||= raw_dc_elements.inject({}) do |hash, element| 
        hash[element.name] = hash[element.name] ? 'multi' : 'single'
        hash
      end
    end
    
    # Identifies which object type the item is a member of
    def is_member_of
      @is_member_of ||= is_member_of_element.to_s.split(':').last
    end
    
    private
    def raw_dc_elements
      @raw_dc_elements ||= doc.xpath(
        '//foxml:datastreamVersion[@ID="DC.1"]//dc:*',
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
  end
end
