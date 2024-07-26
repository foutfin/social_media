require 'rails_helper'


RSpec.describe "Users", type: :request do
  let(:signed_in_user) {
      User.new(
      first_name:"test",
      last_name:"test",
      username:"tests",
      password:"1234567",
      password_confirmation:"1234567",
      email:"abc@abc.com"
    )
  }
  before do
    ActionController::Base.allow_forgery_protection = false
    allow_any_instance_of(UserController).to receive(:home).and_return(signed_in_user)
  end
 

  describe "GET Static pages" do
    it "renders the new view(sign up)" do
      get "/signup"
      expect(response).to render_template(:new)
    end
    it "renders the login view" do
      get "/login"
      expect(response).to render_template("session/loginView")
    end
  end

  describe "GET" do
    it "home feed" do
      get "/home"
      expect(signed_in_user.followed_posts).to eq([])
    end
    it "show user" do
      get "/post"
      expect(signed_in_user.posts).to eq([])
    end
  end

  describe "POST #create" do
    it "adds new user" do
      post '/signup', params: {first_name: "blah", last_name: "blah" , username: "fsfd" , password:"1234567" , password_confirmation:"1234567",email: "Dfgsj@abc.com"}
      expect(response).to redirect_to('/login')
    end
  end

  describe "User Profile" do
    it "user not present" do
      login_as
      get "/user/notfound" 
      expect(response).to render_template("user/notfound")
    end

    it "user exist" do
      login_as
      get "/user/userd"
      expect(assigns(:show_user)).to eq(User.find_by(username: "userd"))
    end

    it "same user" do
      login_as
      get "/user/other"
      expect(assigns(:is_the_same_user)).to eq(true)
    end
  end

  describe "profile update" do
    it "render edit profile" do
      login_as
      get "/profile"
      expect(response).to render_template("user/edit")
    end
  end
end
