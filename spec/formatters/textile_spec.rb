require File.dirname(__FILE__) + '/../spec_helper'

describe "textile formatting" do
  it "should render a textile string as html" do
    Transfigr.format!(:textile, "h1. Foo Dude").should == "<h1>Foo Dude</h1>"
  end
end
