
module Converter
  class XmlToItem
    
    attr_reader :xml
    
    def initialize(xml)
      @xml = xml     
    end
    
    def doc
      @doc ||= Nokogiri::XML xml
    end
    
    def properties
      @properties ||= raw_dc_elements.collect{|e| [e.name, e.text]}
    end
    
    def fields
      @fields  ||= raw_dc_elements.inject({}) do |hash, element| 
        hash[element.name] = hash[element.name] ? 'multi' : 'single'
        hash
      end
    end
    
    def raw_dc_elements
      @raw_dc_elements ||= doc.xpath(
                             '//foxml:datastreamVersion[@ID="DC.1"]//dc:*',
                             namespaces
                           )
    end
    
    def namespaces
      {
        foxml: 'info:fedora/fedora-system:def/foxml#', 
        dc: 'http://purl.org/dc/elements/1.1/'
      }
    end
  end
end
