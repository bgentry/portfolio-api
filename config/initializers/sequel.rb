Sequel::Model.include ActiveModel::Serialization
Sequel::Model.include ActiveModel::Validations

Sequel::Model.plugin :association_dependencies
Sequel::Model.plugin :timestamps, update_on_create: true

Sequel::Model.raise_on_save_failure = false

if Rails.env.development?
   Sequel::DATABASES.each{|d| d.loggers << Logger.new($stdout) }
end
