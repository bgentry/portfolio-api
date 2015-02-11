sm_includes = [ActiveModel::Serialization, ActiveModel::Validations, ActiveModel::Conversion]
sm_includes.each do |i|
  Sequel::Model.include(i)
end

Sequel::Model.plugin :active_model
Sequel::Model.plugin :association_dependencies
Sequel::Model.plugin :timestamps, update_on_create: true

Sequel::Model.raise_on_save_failure = false

Sequel.default_timezone = :utc

if Rails.env.development?
   Sequel::DATABASES.each{|d| d.loggers << Logger.new($stdout) }
end
