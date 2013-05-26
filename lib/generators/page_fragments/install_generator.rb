require 'rails/generators/active_record'
require 'rails/generators/migration'

module PageFragments
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration

      def self.source_root
        @source_root ||= File.join(File.dirname(__FILE__), 'templates')
      end

      def self.next_migration_number(dirname)
        if ActiveRecord::Base.timestamped_migrations
          Time.new.utc.strftime("%Y%m%d%H%M%S")
        else
          "%.3d" % (current_migration_number(dirname) + 1)
        end
      end

      def copy_templates
        copy_file "templates.rb", "config/page_fragments.rb"
      end

      #def copy_locales
      #  copy_file "page_fragments.en.yml", "config/locales/page_fragments.en.yml"
      #end

      #def copy_initialize
      #  template "initialize.rb", "config/initializers/page_fragments.rb"
      #end

      def insert_route
        route 'resources :page_fragments, :only => [:index, :edit, :update, :destroy], :controller => "page_fragments/page_fragments"'
      end

      def create_migration_file
        migration_template 'migration.rb', 'db/migrate/create_page_fragments.rb'
      end

    end
  end
end