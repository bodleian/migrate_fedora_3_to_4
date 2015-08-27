# Gathers source Fedora configuration arguments from configuration file
# Typical usage:
#     source_fedora_config = SourceFedoraConfig.new
#     arguments = source_fedora_config.args
class SourceFedoraConfig
  
  def self.default_yml_file_path
    File.expand_path('config/source_fedora.yml', Rails.root)
  end
  
  attr_reader :yml_file_path
  
  def initialize(yml_file_path = self.class.default_yml_file_path)
    @yml_file_path = yml_file_path
  end
  
  def args
    HashWithIndifferentAccess.new yml
  end
  
  def yml
    YAML.load_file yml_file_path
  end
  
end
