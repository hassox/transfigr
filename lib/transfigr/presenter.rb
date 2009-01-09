module Transfigr
  
  # Use this as a presenter object to access the object by a to_<format> method.
  # This is useful when using something like Merb's display method.
  # It stronly defines presentation logic elsewhere from the object
  #
  # Example
  # 
  #   display Transfigr.presenter(@article)
  #
  #   Tranfigr.presenter(@article).to_textile
  #
  # :api: public
  def self.presenter(object, opts = {})
    Presenter.new(object, opts)    
  end
  
  # :api: private
  class Presenter
    attr_reader :target, :options
    
    def initialize(target, options = {})   
      @target, @options = target, options
    end
    
    # Need to undefine all the to_xxx methods
    to_methods = self.instance_methods.grep(/^to_/)
    to_methods.each do |meth|
      undef_method meth.to_sym unless meth == "to_s" || meth == "to_string"
    end
    
    # Adds a formatter to the presenter
    # :api: private
    def self.add_format!(format)
      self.class_eval <<-RUBY
        def to_#{format}
          Transfigr.format!(:#{format}, target, options)
        end
      RUBY
    end
    
    # Removes the formatter method from the presenter
    # :api: private
    def self.remove_format!(format)
      undef_method :"to_#{format}"
    end
    
    # :api: overwritable
    def method_missing(name, *rest)
      raise FormatterNotFound, "No active #{name.inspect} format was found" if name.to_s =~ /^to_/
      super
    end
    
  end # Presenter
end # Transfigr