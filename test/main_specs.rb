require_relative 'test_helper'

describe "Main Application Interactions" do

  it "should successfully render the homepage" do
    get '/'
    last_response.ok?.must_equal true
    last_response.body.must_include '<h1>Blackjack <small>a Sinatra Webapp</small></h1>'
  end

end
