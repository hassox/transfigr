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
    
    def format!
      BlueCloth.new(target).to_html
    end
  end
end