require "rails"
require "page_fragments/version"

module PageFragments
  #def self.config
  #  yield self
  #end

  def self.templates &block
    self::PageFragment.config &block
  end

  class Railtie < Rails::Railtie
    rake_tasks do
      load File.join(File.dirname(__FILE__), 'tasks/pf.rake')
    end
  end

  class Engine < Rails::Engine
  end

end
