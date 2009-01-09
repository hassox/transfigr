require 'rubygems'

module Transfigr
  class MissingFormatMethod < Exception; end
  class FormatterNotFound < Exception; end
  
  class << self
    # Use the format method to format an object via a given formatter
    # Normally this would be a string, but it could be anything.
    # 
    # Example: 
    #   
    #   Transfigr.format!(:textile, "h1. I'm a textile string")
    #
    # :api: public
    def format!(format, object, opts = {})
      raise "#{format.inspect} is not an active format" unless active?(format)
      self[format].new(object).format!(opts)
    end
  
    # Activate formatters that you want to actually use.  This 
    # allows formatters to be loaded, but not actually activated,
    # leaving their dependencies behind.  Activation can be done implicitly
    # by just using a registered format.
    #
    # :api: public
    def activate!(*args)
      args.each do |f|
        fmtr = formatters[f]
        raise "No Formatter found for format #{f.inspect}" unless fmtr
        _active_formats[f.to_s] = f
        Presenter.add_format!(f)
        fmtr.after_activation.call if fmtr.after_activation
        true
      end
    end
    
    # Deactivate and already active format
    #
    # :api: public
    def deactivate!(*args)
      args.each do |f|
        _active_formats.delete(f.to_s)
        Presenter.remove_format!(f)
      end
    end
    
    # Allows you to add a formatter.  A formatter should 
    # At minimum define a format!(opts={}) method.  
    # I there is no format! method Transfigr::MissingFormatMethod will be raised
    # 
    # Example
    #
    #   Transfigr.add(:foo) do
    #     def format!(opts = {})
    #       "<foo>#{target}</foo>"
    #     end
    #   end
    #
    # :api: public
    def add(name, &block)
      formatter = Class.new(Formatter, &block)
      raise MissingFormatMethod unless formatter.instance_methods.include?("format!")
      self.formatters[name] = formatter
    end
    
    # Provides acces to edit the formatter.  It's the same as getting another crack
    # at the add block
    # 
    # Example
    # 
    #   Transfigr.edit(:foo){ def my_helper; "bar"; end }
    #
    # :api: public
    def edit(name, &block)
      fmtr = formatters[name]
      raise FormatterNotFound unless fmtr
      fmtr.class_eval(&block)
    end
     
    # Provides a list of currently active formats
    # :api: public
    def active_formats
      _active_formats.keys.sort
    end
    
    # Check to see if a format has been activated
    # :api: public
    def active?(format)
      !!_active_formats[format.to_s]
    end
    
    # Checks to see if a formatter has been defined
    # :api: public
    def defined?(format)
      formatters.keys.include?(format)
    end
    
    protected
    # provides a list of declared formatters
    # :api: private
    def formatters
      @formatters ||= {}
    end

    private
    # Provides access to the formatter
    # :api: private
    def [](formatter)
      formatters[_active_formats[formatter.to_s]]
    end
    
    # A hash of active formats with the format_as as the key, and the class as the value
    # :api: private
    def _active_formats
      @_active_formats ||= {}
    end
    

  end # self
end # Transfigr

$:.unshift File.dirname(__FILE__)
require 'transfigr/presenter'
require 'transfigr/abstract_formatter'
require 'transfigr/formatters/markdown'
require 'transfigr/formatters/textile'