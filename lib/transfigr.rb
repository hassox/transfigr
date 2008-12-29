require 'rubygems'

module Transfigr
  class << self
    # Use the format method to format a string via a given formatter
    # 
    # Example: 
    #   
    #   Transfigr.format!(:textile, "h1. I'm a textile string")
    #
    # :api: public
    def format!(format, string)
      activate!(format) unless active?(format)
      self[format].format!(string)
    end
  
    # Activate formatters that you want to actually use.  This 
    # allows formatters to be loaded, but not actually activated,
    # leaving their dependencies behind.  Activation can be done implicitly
    # by just using a registered format.
    #
    # :api: public
    def activate!(*args)
      args.each do |f|
        fmtr = formatters.detect{|fmt| fmt.format_as == f}
        raise "No Formatter found for format #{f.inspect}" unless fmtr
        _active_formats[f] = fmtr
        fmtr.after_activation.call if fmtr.after_activation
      end
    end
    
    # Provides a list of currently active formats
    # :api: public
    def active_formats
      _active_formats.keys
    end
    
    # Check to see if a format has been activated
    # :api: public
    def active?(format)
      !!_active_formats[format]
    end
    
    protected
    # provides a list of declared formatters
    # :api: private
    def formatters
      @formatters ||= []
    end

    private
    # Provides access to the formatter
    # :api: private
    def [](formatter)
      _active_formats[formatter]
    end
    
    # A hash of active formats with the format_as as the key, and the class as the value
    # :api: private
    def _active_formats
      @_active_formats ||= {}
    end
    

  end # self
end # Transfigr

$:.unshift File.dirname(__FILE__)
require 'transfigr/abstract_formatter'
require 'transfigr/formatters/markdown'
require 'transfigr/formatters/textile'