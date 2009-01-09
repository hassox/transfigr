Transfigr.add(:markdown) do
  after_activation do
    begin
      require 'rdiscount'
      BlueCloth = RDiscount
    rescue LoadError
      require 'bluecloth'
    end
  end
  
  def format!(opts = {})
    BlueCloth.new(target).to_html
  end
end