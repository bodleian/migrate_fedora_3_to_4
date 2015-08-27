namespace :fedora3to4 do
  desc 'Imports data from fedora 3 instance'
  task :import  => :environment do
    source_fedora_config = SourceFedoraConfig.new
    Process::ImportFedora3Ids.run source_fedora_config.args
    Item.all.each do |item|
      Process::ItemPopulator.do_for(item, source_fedora_config.args)
      print '.'
    end
    puts "\nTask complete\n"
  end
end