Transfigr.add(:textile) do
  after_activation do
    require 'redcloth'
  end
    
  def format!(opts = {})
    RedCloth.new(target).to_html
  end
end
