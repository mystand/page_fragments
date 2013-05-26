module PageFragments
  class PageFragment < ActiveRecord::Base
    default_scope where(:hidden => false) if self.column_names.include?('hidden')
    attr_accessible :key, :content

    KEY_REGEXP = /^[a-z_.]+$/
    AVAILABLE_CONTENT_TYPES = [:text, :string, :integer]

    before_save :validate

    validates :key, :uniqueness => true, :presence => true, :format => {:with => KEY_REGEXP}

    serialize :validation, Hash

    def self.config &block
      if PageFragment.table_exists?
        if PageFragment.column_names.include?('hidden')
          PageFragment.all.each { |pf| pf.hidden = true; pf.save(:validate => false) }
        end
        PageFragment::Configuring.instance_eval(&block)
      end
    end

    def self.get *keys
      key = PageFragment.parse_key keys.flatten
      PageFragment.where(:key => key).first || raise(ActiveRecord::RecordNotFound)
    end

    def self.set keys, value
      item = PageFragment.get(keys)
      item.content = value
      item.save
      item
    end

    def to_s
      I18n.t("page_fragments.#{self.key}.name")
    end

    def parents
      names = []
      self.keys.each { |k| names << [names.last, k].join(".") }
      names
    end

    def short_name
      I18n.t("page_fragments.#{self.key}.name")
    end

    def keys
      (self.key || "").split(".")
    end

    def nesting_level
      self.keys.size
    end

    def type? target
      if target.is_a? Array
        target.map { |t| t.to_s }.include?(self.content_type)
      else
        self.content_type == target.to_s
      end
    end

    private

    def self.parse_key *keys
      keys.flatten.map { |k| k.to_s }.join(".") #its for i18n
    end

    def validate
      return if self.new_record?
      self.validation.each do |name, options|
        case options
          when TrueClass
            options = {}
          when Hash
            options
          when Range, Array
            options = {:in => options}
          else
            options = {:with => options}
        end
        options[:attributes] = [:content]
        begin
          validator_name = (name.to_s.camelize + "Validator")
          validator_class = ("ActiveModel::Validations::" + validator_name).constantize
        rescue
          raise "can't find validator #{validator_name}"
        end
        validator = validator_class.new(options)
        validator.validate(self)
      end
      self.errors.empty?
    end


    module Configuring
      #def self.validates options, &block
      #  PageFragment::Configuring.instance_eval(&block)
      #end

      def self.fragment *args
        type = args.delete(args.first)
        params = args.last.is_a?(Hash) ? args.delete(args.last) : {}
        keys = args.flatten
        PageFragment::Configuring.init type, keys, params
      end

      def self.init type, keys, validation
        key = PageFragment.parse_key keys.flatten
        item = PageFragment.unscoped.where(:key => key).first || PageFragment.new(:key => key)
        raise "unexpected type of fragment" unless AVAILABLE_CONTENT_TYPES.include? type
        item.content_type = type.to_s
        item.validation = validation
        item.hidden = false if PageFragment.column_names.include?('hidden')
        item.save
      end
    end
  end
end

