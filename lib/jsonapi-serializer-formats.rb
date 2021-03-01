module JSONAPI
  module Formats
    extend ActiveSupport::Concern

    included do
      class << self 

        def scoped_formats
          @scoped_formats ||= []
        end

        def formats_per_attr
          @formats_per_attr ||= {}
        end
  
        # --- Override the attribute and relationship methods to support contexts

        [
          :attributes,
          :belongs_to,
          :has_many,
          :has_one
        ].each do |method_name|

          original_method_name = "jsonapi_#{method_name}".to_sym

          alias_method original_method_name, method_name

          define_method(method_name) do |*attributes_list, &block|

            # --- If we're not in a format blocked, pass through

            return send(original_method_name, *attributes_list, &block) unless scoped_formats.length.positive?
              
            # --- Read options hash (if present)

            opts = attributes_list.last
            unless opts.is_a?(Hash)
              opts = {}
              attributes_list << opts
            end

            user_condition = opts[:if] || Proc.new { true }
            
            attributes_list[0..-2].each do |field|

              (formats_per_attr[field] ||= []) << [*scoped_formats]
              
              # --- Inject an :if condition

              field_opts = opts.dup
              field_opts[:if] = Proc.new do |_, params = {}|
                if !user_condition.call(_, params)
                  next false # --- The user's condition failed
                end

                render_formats = [params[:format]].compact.flatten

                # --- Return true if the user passed the require formats as params

                formats_per_attr[field].any? do |formats|
                  formats.all? { |f| render_formats.include?(f) }
                end
              end

              send(original_method_name, *[field, field_opts], &block)
            end
          end
        end
  
        #
        # Defines a named format with a block
        #
        # @param [Symbol] fmt the name of the format you wish to create
        #
        #
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
