require File.dirname(__FILE__) + '/../spec_helper'

describe "markdown formatting" do
  it "should render a textile string as html" do
    Transfigr.format!(:markdown, "I'm biched _es_").should match(/^<p>I'm biched <em>es<\/em><\/p>/)
  end
end