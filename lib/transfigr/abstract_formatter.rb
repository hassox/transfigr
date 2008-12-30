module Transfigr
  # Transfigr::Formatter is the base class to inherit from when developing your own formatters
  class Formatter
    attr_accessor :target
    
    def initialize(target)
      @target = target
    end
    
    # This is where the work is done in formatting.
    # This method recieves a string to transform, and shoul
    # format the result
    # :api: overwritable
    def format!
      raise NoMethodError, "You have not defined the format! method for the #{self.class.name} Formatter"
    end
  
    # This method allows you to register the formatter.  This label will be used when 
    # declaring format to transfigure to
    #
    # Example
    #  
    #   class MyFormatter < Transfigr::Formatter
    #     format_as :my_foo
    #
    #     def self.format!(string)
    #       # format in here
    #     end
    #  end
    #
    # Usage is then Transfigr.format!(:my_foo, "string to format")
    # :api: plugin
    def self.format_as(format = nil)
      format.nil? ? @format : (@format = format)
    end
    
    # The after_activation block allows you to call code after the formatter has been activated.
    # This includes requireing any dependencies
    #
    # Example 
    # 
    #   class MyFoo < Transfigr::Formatter
    #     # snip
    #     after_activation{ require "foo" }
    #     #snip
    #   end
    #
    # :api: plugin
    def self.after_activation(&block)
      @after_activation = block if block_given?
      @after_activation
    end
    
    private
    # Adds this formatter to the list of formatters available to activate
    # :api: private
    def self.inherited(base)
      Transfigr.formatters << base
    end
  end
end