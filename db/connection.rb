ActiveRecord::Base.configurations = YAML.load_file('config.yml')['database']
ActiveRecord::Base.establish_connection('development')