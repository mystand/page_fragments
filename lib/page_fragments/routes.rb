module ActionDispatch::Routing
  class Mapper
    def devise_for(*resources)
      options = resources.extract_options!

      options[:as]          ||= @scope[:as]     if @scope[:as].present?
      options[:module]      ||= @scope[:module] if @scope[:module].present?
      options[:path_prefix] ||= @scope[:path]   if @scope[:path].present?
      options[:path_names]    = (@scope[:path_names] || {}).merge(options[:path_names] || {})
      options[:constraints]   = (@scope[:constraints] || {}).merge(options[:constraints] || {})
      options[:defaults]      = (@scope[:defaults] || {}).merge(options[:defaults] || {})
      options[:options]       = @scope[:options] || {}
      options[:options][:format] = false if options[:format] == false

      resources.map!(&:to_sym)

      resources.each do |resource|
        mapping = Devise.add_mapping(resource, options)

        begin
          raise_no_devise_method_error!(mapping.class_name) unless mapping.to.respond_to?(:devise)
        rescue NameError => e
          raise unless mapping.class_name == resource.to_s.classify
          warn "[WARNING] You provided devise_for #{resource.inspect} but there is " <<
                   "no model #{mapping.class_name} defined in your application"
          next
        rescue NoMethodError => e
          raise unless e.message.include?("undefined method `devise'")
          raise_no_devise_method_error!(mapping.class_name)
        end

        routes  = mapping.used_routes

        devise_scope mapping.name do
          if block_given?
            ActiveSupport::Deprecation.warn "Passing a block to devise_for is deprecated. " \
              "Please remove the block from devise_for (only the block, the call to " \
              "devise_for must still exist) and call devise_scope :#{mapping.name} do ... end " \
              "with the block instead", caller
            yield
          end

          with_devise_exclusive_scope mapping.fullpath, mapping.name, options do
            routes.each { |mod| send("devise_#{mod}", mapping, mapping.controllers) }
          end
        end
      end
    end
  end
end