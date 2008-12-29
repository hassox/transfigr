module Transfigr
  class MarkdownFormatter < Formatter
    format_as :markdown
    
    after_activation do
      begin
        require 'rdiscount'
        BlueCloth = RDiscount
      rescue LoadError
        require 'bluecloth'
      end
    end
    
    def self.format!(string)
      BlueCloth.new(string).to_html
    end
  end
end