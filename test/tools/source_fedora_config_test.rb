

class SourceFedoraConfigTest < ActiveSupport::TestCase
  
  def test_default_yml_file_path
    expected = "#{Rails.root}/config/source_fedora.yml"
    assert_equal expected, SourceFedoraConfig.default_yml_file_path
  end
  
  def test_args
    assert_kind_of HashWithIndifferentAccess, source_fedora_config.args
    assert_equal fedora_config_yml, source_fedora_config.args
  end
  
  
  def source_fedora_config
    @source_fedora_config ||= SourceFedoraConfig.new(fedora_config_yml_path)
  end
  
end
