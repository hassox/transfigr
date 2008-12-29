module Transfigr
  class TextileFormatter < Formatter
    format_as :textile
    
    after_activation do
      require 'redcloth'
    end
    
    def self.format!(string)
      RedCloth.new(string).to_html
    end
  end
end