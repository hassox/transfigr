module Transfigr
  class TextileFormatter < Formatter
    format_as :textile
    
    after_activation do
      require 'redcloth'
    end
      
    def format!
      RedCloth.new(target).to_html
    end
  end
end