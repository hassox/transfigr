require File.dirname(__FILE__) + '/spec_helper'

describe "transfigr" do
  before(:each){$captures = []}
    
  it "should allow a developer to activate a formatter" do
    class Foo1Formatter < Transfigr::Formatter; format_as :foo1; end
    Transfigr.activate!(:foo1)
    Transfigr.active?(:foo1).should be_true
  end
  
  it "should allow activation of multiple formatters" do
    class Foo2Formatter < Transfigr::Formatter; format_as :foo2; end
    class Foo3Formatter < Transfigr::Formatter; format_as :foo3; end
    Transfigr.activate!(:foo2, :foo3)
    [:foo2, :foo3].each do |foo|
      Transfigr.active?(foo).should be_true
    end
  end
  
  it "should not be activated for a formatter that has not been activate" do
    class Foo4Formatter < Transfigr::Formatter; format_as :foo4; end
    Transfigr.active?(:foo4).should be_false
  end
  
  it "should allow the formatter to run after_activation code" do
    class Foo6Formatter < Transfigr::Formatter
      format_as :foo6
      after_activation do
        $captures << :foo6
      end
    end
    Transfigr.activate!(:foo6)
    $captures.should == [:foo6]
  end
  
  it "should not run the after_Activation code if the formatter has not been activated" do
    class Foo7Formatter < Transfigr::Formatter
      format_as :foo7
      after_activation do
        $captures << :foo7
      end
    end
    $captures.should_not include(:foo7)
  end
  
  it "should raise an exception when trying to format with a formatter that has not implented the format! method" do
    class Foo8Formatter < Transfigr::Formatter
      format_as :foo8
    end
    Transfigr.activate!(:foo8)
    lambda do 
      Transfigr.format!(:foo8, "bar")
    end.should raise_error(NoMethodError)
  end
  
  it "should format a string with the provided fromatter" do
    class Foo9Formatter < Transfigr::Formatter
      format_as :foo9
      def self.format!(string)
        ":foo9 - #{string}"
      end
    end
    Transfigr.activate!(:foo9)
    Transfigr.format!(:foo9, "foobar").should == ":foo9 - foobar"
    Transfigr.format!("foo9", "bazbar").should == ":foo9 - bazbar"
  end
end