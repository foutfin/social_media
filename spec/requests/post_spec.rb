require 'rails_helper'


RSpec.describe "Posts", type: :request do
  before do
    ActionController::Base.allow_forgery_protection = false
  end
 

  describe "GET post" do
    it "[[ must be login ]]" do
      get "/post/72"
      expect(response).to redirect_to('/signup')
    end
    
    it "[[ post not found ]]" do
      login_as
      get "/post/10"
      expect(response).to render_template("post/post_not_found")
    end

    it "[[ same user post ]]" do
      login_as
      get "/post/72"
      expect(assigns(:same_user)).to eq(true)
    end
    
    it "[[ not able to see unfollowed user post ]]" do
      login_as
      get "/post/61"
      expect(assigns(:is_friend)).to eq(false)
    end
  end

  describe "Get #edit" do
    it "[[ render post edit layout ]]" do
      login_as
      get "/post/72/edit" 
      expect(response).to render_template("post/edit")
    end
  end

  describe "Destroy action" do
      it "[[ Delete the post ]]" do
        login_as
        delete "/post/83"
        parsed_res = JSON.parse(response.body)
        expect(parsed_res["msg"]).to eq("ok")
      end
  end


  describe "Like action " do
    it "[[ post not found ]]" do
      login_as
      get "/post/10/like"
      parsed_res = JSON.parse(response.body)
      expect(parsed_res["err"]).to eq("post not found")
    end

 
    it "[[ Like a post ]]" do
      login_as
      get "/post/72/like" 
      parsed_res = JSON.parse(response.body)
      expect(parsed_res["msg"]).to eq("ok")
    end

  end

  describe "DisLike action " do
    it "[[ post not found ]]" do
      login_as
      get "/post/10/dislike"
      parsed_res = JSON.parse(response.body)
      expect(parsed_res["err"]).to eq("post not found")
    end

    it "[[ Like a post ]]" do
      login_as
      get "/post/72/dislike" 
      parsed_res = JSON.parse(response.body)
      expect(parsed_res["msg"]).to eq("ok")
    end

  end

  describe "Archive Post" do
    it "[[ post not found ]]" do
      login_as
      get "/post/10/archive"
      parsed_res = JSON.parse(response.body)
      expect(parsed_res["err"]).to eq("Post is not found")
    end

    it "[[ Like a post ]]" do
      login_as
      get "/post/72/archive" 
      parsed_res = JSON.parse(response.body)
      expect(parsed_res["msg"]).to eq("ok")
    end
  end

  describe "POST #create" do
    it "add a new post" do
      login_as

      post '/post', params: {caption: "blah", body: "Body" }
      expect(flash[:error]).to eq([])
      expect(response).to redirect_to('/post')
    end

    it "is not valid without caption " do
      login_as
      post '/post', params:  {caption: "", body: "Body" }
      # byebug
      expect(flash[:error]).to eq(["Missing caption"])
    end 

    it "is not valid if both media and body not present " do
      login_as
      post '/post', params:  {caption: "Caption ", body: "" ,media: nil }
      expect(flash["error"]).to eq(["Both body and media can't be empty"])
    end 
    
  end


end
