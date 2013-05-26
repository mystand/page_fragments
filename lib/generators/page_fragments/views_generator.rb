module PageFragments
  module Generators
    class ViewsGenerator < Rails::Generators::Base
      include Rails::Generators::Migration

      def self.source_root
        @source_root = File.join(File.dirname(__FILE__), '../../../app/views/page_fragments/page_fragments')
      end

      def copy_vies
        copy_file "index.html.haml", "app/views/page_fragments/page_fragments/index.html.haml"
        copy_file "edit.html.haml", "app/views/page_fragments/page_fragments/edit.html.haml"
      end

    end
  end
end