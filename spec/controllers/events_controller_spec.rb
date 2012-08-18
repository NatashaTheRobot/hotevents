require 'spec_helper'

describe EventsController do

  describe "GET 'index.html.haml'" do
    it "returns http success" do
      get 'index.html.haml'
      response.should be_success
    end
  end

end
