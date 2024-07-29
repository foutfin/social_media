require 'rails_helper'


RSpec.describe "Session", type: :request do

  before do
    ActionController::Base.allow_forgery_protection = false
  end

  describe "Login" do
    it "[[ Successful Login ]]" do
      login_as
      post '/login', params: {username: "test", password: "1234567" }
      expect(response).to redirect_to('/home')
    end

    it "is not valid without username " do
      login_as
      post '/login', params:  {username: "", password: "1234567" }
      expect(flash[:error]).to eq(["Missing username"])
    end 
  
    it "is not valid without password" do
      login_as
      post '/login', params:  {username: "test", password: "" }
      expect(flash[:error]).to eq(["Missing password"])
    end 

    it "wrong credentials " do
      login_as
      post '/login', params:  {username: "test", password: "12345678" }
      expect(flash["error"]).to eq(["check username and password"])
    end 
  end
end
