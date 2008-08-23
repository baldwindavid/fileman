class FilemanGenerator < Rails::Generator::NamedBase
  def manifest
    record do |m|
      m.directory "app/views/fileman"
      m.file "app/views/fileman/_form.haml", "app/views/fileman/_form.haml"
      m.file "app/views/fileman/_list_item.haml", "app/views/fileman/_list_item.haml"
      m.file "app/views/fileman/_add_facility.haml", "app/views/fileman/_add_facility.haml"
      m.directory "app/views/#{plural_name}"
      m.template "app/views/fileman/index.haml", "app/views/#{plural_name}/index.haml"
      m.template "app/models/fileman.rb", "app/models/#{singular_name}.rb"
      m.template "app/controllers/fileman_controller.rb", "app/controllers/#{plural_name}_controller.rb"
      m.migration_template 'db/migrate/migration.rb',"db/migrate", :migration_file_name => "create_#{plural_name}"
    end
  end
end
