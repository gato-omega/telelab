raw_config = File.read("#{Rails.root}/config/app_config.yml")

def recursive_symbolize_keys! hash
 hash.symbolize_keys!
 hash.values.select{|v| v.is_a? Hash}.each{|h| recursive_symbolize_keys!(h)}
end

APP_CONFIG = YAML.load(raw_config)[Rails.env]
recursive_symbolize_keys! APP_CONFIG