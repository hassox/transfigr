module Transfigr
  # Transfigr::Formatter is the base class to inherit from when developing your own formatters
  class Formatter
    attr_accessor :target
    
    def initialize(target)
      @target = target
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
  end
end