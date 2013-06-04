module MadCart
  module Model
    module Base
      def initialize(args={})
        self.additional_attributes = {}

        self.class.required_attrs.each do |attr|
          raise(ArgumentError, "missing argument: #{attr}") if !args.keys.map{|a| a.to_s }.include? attr
        end

        args.each do |k,v|
          if self.class.required_attrs.include? k.to_s
            self.send("#{k}=", v) unless v.nil?
          else
            self.additional_attributes[k.to_s] = v unless v.nil?
          end
        end
      end

      def self.included(base)
        base.extend(ClassMethods)
        base.class_eval do
          include(AttributeMapper)
          include(InheritableAttributes)
          attr_accessor :additional_attributes
          inheritable_attributes :required_attrs
        end
      end

      module ClassMethods
        def required_attributes(*args)
          @required_attrs = args.map{|a| a.to_s }
          attr_accessor(*args)
        end
      end
    end
  end
end
