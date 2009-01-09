require File.dirname(__FILE__) + '/spec_helper'

describe "transfigr" do
  before(:each){$captures = []}
    
  it "should allow a developer to activate a formatter" do
    Transfigr.add(:foo1){ def format!(opts={}); end }
    Transfigr.activate!(:foo1)
    Transfigr.active?(:foo1).should be_true
  end
  
  it "should allow activation of multiple formatters" do
    Transfigr.add(:foo2){ def format!(opts={}); end }
    Transfigr.add(:foo3){ def format!(opts={}); end }
    Transfigr.activate!(:foo2, :foo3)
    [:foo2, :foo3].each do |foo|
      Transfigr.active?(foo).should be_true
    end
  end
  
  it "should raise and exception if there is no format! method defined" do
    lambda do
      Transfigr.add(:no_format_foo){ }
    end.should raise_error(Transfigr::MissingFormatMethod)
  end
  
  it "should not define a format! method on the base class" do
    Transfigr::Formatter.instance_methods.should_not include("format!")
  end
  
  it "should not be activated for a formatter that has not been activate" do
    Transfigr.add(:foo4){ def format!(opts={}); end }
    Transfigr.active?(:foo4).should be_false
  end
  
  it "should allow the formatter to run after_activation code" do
    Transfigr.add(:foo5) do
      after_activation { $captures << :foo5 }
      def format!(opts={}); end
    end
    Transfigr.activate!(:foo5)
    $captures.should == [:foo5]
  end
  
  it "should not run the after_Activation code if the formatter has not been activated" do
    Transfigr.add(:foo6) do
      after_activation{ $captuers << :foo6 }
      def format!(opts={}); end
    end
    $captures.should_not include(:foo6)
  end
  
  it "should format a string with the provided fromatter" do
    Transfigr.add(:foo8) do
      def format!(opts = {})
        ":foo8 - #{target}"
      end
    end
    Transfigr.activate!(:foo8)
    Transfigr.format!(:foo8, "foobar").should == ":foo8 - foobar"
    Transfigr.format!("foo8", "bazbar").should == ":foo8 - bazbar"
  end
  
  it "should allow for options to be passed to the format" do
    Transfigr.add(:foo9) do
      def format!(opts = {})
        ":foo9 - #{target} - #{opts.inspect}"
      end
    end
    Transfigr.activate!(:foo9)
    Transfigr.format!(:foo9, "string", :foo => :bar).should == ":foo9 - string - {:foo=>:bar}"
  end
  
  it "should allow me to edit a formatter" do
    Transfigr.add(:foo10){ def format!(o={}); $captures << :original; end }
    Transfigr.activate!(:foo10)
    Transfigr.format!(:foo10, :foo)
    Transfigr.edit(:foo10){ def format!(o={}); $captures << :modified; end}
    Transfigr.format!(:foo10, :foo)
    $captures.should == [:original, :modified]
  end
  
  it "should raise an exception if a formatter is edited that does not exist" do
    lambda do
      Transfigr.edit(:will_never_exist){ def format!(o); "foo"; end }
    end.should raise_error(Transfigr::FormatterNotFound)
  end
  
  it "should allow me to replace a formatter" do
    Transfigr.add(:foo11) do
      def helper; :helper; end
      def format!(o); $captures << :noooo; end 
    end
    Transfigr.activate!(:foo11)
    Transfigr.add(:foo11) do
      def format!(o)
        $captures << :yeeees
        $captures << self.respond_to?(:helper)
      end
    end
    
    Transfigr.format!(:foo11, "")
    $captures.should == [:yeeees, false]
  end
  
  it "should allow you to deactivate a format" do
    Transfigr.add(:foo12){ def format!(o); :foo12; end }
    Transfigr.activate!(:foo12)
    Transfigr.should be_active(:foo12)
    Transfigr.deactivate!(:foo12)
    Transfigr.should_not be_active(:foo12)
  end
  
  it "should tell you if a formatter has been defined" do
    Transfigr.should_not be_defined(:to_be_defined)
    Transfigr.add(:to_be_defined){ def format!(o); :foo; end }
    Transfigr.should be_defined(:to_be_defined)
  end
end