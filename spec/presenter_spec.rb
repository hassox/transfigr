require File.dirname(__FILE__) + '/spec_helper'

describe "Transfigr.presenter(obj)" do
  
  it "should setup a presenter" do
    Transfigr.presenter(Object.new).should be_an_instance_of(Transfigr::Presenter)
  end
  
  it "should allow me to call me to call a format via to_<format> on an activated format" do
    Transfigr.add(:active_presenter_format) do
      def format!(o)
        :presenter_format_formatted
      end
    end
    Transfigr.activate!(:active_presenter_format)
    Transfigr.presenter(Object.new).to_active_presenter_format.should == :presenter_format_formatted
  end
  
  it "should raise a FormatterNotFound when calling to_<unknown_format>" do
    Transfigr.should_not be_defined(:not_defined)
    lambda do
      Transfigr.presenter(Object.new).to_not_defined
    end.should raise_error(Transfigr::FormatterNotFound)
  end
  
end