module JSONAPI
  module Formats
    def hello
      "hi"
    end

    module_function :hello

    def self.included(base)
      base.class_eval do
        class << self 
          def scoped_formats
            @@scoped_formats ||= []
          end
    
          alias_method :jsonapi_attributes, :attributes
    
          #
          # Override the attribute method to support contexts
          #
          def attributes(*attributes_list, &block)
            formats = [*scoped_formats]
    
            if formats.length.positive?
              opts = attributes_list.last
              unless opts.is_a?(Hash)
                opts = {}
                attributes_list << opts
              end
    
              cond = opts[:if]
              opts[:if] = Proc.new do |_, params = {}|
                next false if cond.present? && !cond.call(_, params)
                render_formats = [params[:format]].compact.flatten
    
                formats.all? { |f| render_formats.include?(f) }
              end
            end
    
            jsonapi_attributes(*attributes_list, &block)
          end
    
          def format(fmt)
            scoped_formats.push(fmt)
            yield
          ensure
            scoped_formats.pop
          end
    
          alias_method :attribute, :attributes
        end
      end
    end
  end
end
