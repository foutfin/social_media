require 'rails_helper'

RSpec.describe "V1::PostApi" , '/api/post' do

  let(:post_data)  { { caption: "caption-1" , body: "body-1" }}
  let(:user) {{ username: "test" , password: "1234567" }}
 
  describe "POST /api/post" do

    it "cannot access without authorized" do
      post "/api/post" ,params: post_data
      json_body = JSON.parse(response.body)
      expect(json_body["status"]).to eq(401)
      expect(json_body["error"]).to eq(["unauthorized"])
    end

    context "with all required fields(caption and at_least_one [ body , media])" do
      it 'creates a new post' do
        expect do 
         auth_header = jwt_login user
         post "/api/post" , params: post_data , headers: { "Authorization": "Bearer #{auth_header}" }
        end.to change(Post,:count).by 1
      end

      it 'record exist in database' do
        auth_header = jwt_login user
        post "/api/post" , params: post_data , headers: { "Authorization": "Bearer #{auth_header}" }
        json_body = JSON.parse(response.body)
        post = Post.find_by(id: json_body["post_id"]) 
        expect(post.present?).to eq(true)
      end

      it 'correct response msg' do
        auth_header = jwt_login user
        post "/api/post" , params: post_data , headers: { "Authorization": "Bearer #{auth_header}" }
        json_body = JSON.parse(response.body)
        expect(json_body["status"]).to eq(200)
        expect(json_body.key?("post_id")).to eq(true)
      end

    end

    context "not valid if field " do

      it "caption , media , body not present" do
        auth_header = jwt_login user
        post "/api/post"  , headers: { "Authorization": "Bearer #{auth_header}" }
        json_body = JSON.parse(response.body)
        expect(json_body["error"]).to eq("caption is missing, media, body are missing, at least one parameter must be provided")
      end

      it 'caption not present' do
        auth_header = jwt_login user
        post "/api/post" , params: { body: "body"} , headers: { "Authorization": "Bearer #{auth_header}" }
        json_body = JSON.parse(response.body)
        expect(json_body["error"]).to eq("caption is missing")
      end

      it 'media and body both not present' do
        auth_header = jwt_login user
        post_data["body"] = nil
        post "/api/post" , params: { caption: "caption"} , headers: { "Authorization": "Bearer #{auth_header}" }
        json_body = JSON.parse(response.body)
        expect(json_body["error"]).to eq("media, body are missing, at least one parameter must be provided")
      end

    end
  end

  
  describe "GET /api/post" do
    
    it "cannot access without authorized" do
      get "/api/post" 
      json_body = JSON.parse(response.body)
      expect(json_body["status"]).to eq(401)
      expect(json_body["error"]).to eq(["unauthorized"])
    end
    
    it "valid no of posts exist in database" do
      response = get_request_with_auth(user,"/api/post")
      user = User.find_by(username: "test")
      expect(response["res"].length).to eq(user.posts.length)
    end

    it "have correct response msg" do
      res = get_request_with_auth(user,"/api/post")
      expect(res["status"]).to eq(200)
      expect(res.key?("res")).to eq(true)
    end
  end

  describe "PUT /api/post/archive" do
    
    it "cannot access without authorized" do
      put "/api/post/archive" ,params: { post_id: "23"} 
      json_body = JSON.parse(response.body)
      expect(json_body["status"]).to eq(401)
      expect(json_body["error"]).to eq(["unauthorized"])
    end
    
    context do
      post_id = "987"

      it " post_id not exist in params " do
        response = put_request_with_auth(user , "/api/post/archive" , {})
        expect(response["error"]).to eq("post_id is missing")
      end
    
    it "if post not exist [database check]" do
      put_request_with_auth(user , "/api/post/archive" , { post_id: post_id })
      post = Post.find_by(id: post_id)
      expect(post.present?).to eq(false)
    end

    it "if post not exist " do
      response = put_request_with_auth(user , "/api/post/archive" , { post_id: post_id})
      expect(response["status"]).to eq(404)
      expect(response["error"]).to eq(["post not found"])
    end
    end

    context do 
      post_id = "61"
      it "for valid post [database update]" do
        put_request_with_auth(user , "/api/post/archive" , { post_id: post_id})
        post = Post.find_by(id: post_id)
        expect(post.present?).to eq(true)
        expect(post.archived).to eq(true)
      end

      it "for valid post [response]" do
        response = put_request_with_auth(user , "/api/post/archive" , { post_id: post_id})
        expect(response["status"]).to eq(200)
        expect(response["msg"]).to eq("ok")
      end
    
    end

  end

  describe "GET /api/post/:post_id" do
    
    it "cannot access without authorized" do
      get "/api/post/61" 
      json_body = JSON.parse(response.body)
      expect(json_body["status"]).to eq(401)
      expect(json_body["error"]).to eq(["unauthorized"])
    end

    context do
      post_id = "987"

      it "if post not exist [database check]" do
        get_request_with_auth(user , "/api/post/#{post_id}" )
        post = Post.find_by(id: post_id)
        expect(post.present?).to eq(false)
      end

      it "if post not exist [response msg check]" do
        response = get_request_with_auth(user , "/api/post/#{post_id}" )
        expect(response["status"]).to eq(404)
        expect(response["error"]).to eq(["post not found"])
      end
    end
    
    context "not have connection(follower or following)" do
      post_id = 3
      it "post not exist " do
        response = get_request_with_auth(user , "/api/post/#{post_id}" )
        expect(response["status"]).to eq(404)
        expect(response["error"]).to eq(["post not found"])
      end
      
      it "not in follower and following list" do
        post_id = 110
        response = get_request_with_auth(user , "/api/post/#{post_id}" )
        expect(response["status"]).to eq(403)
        expect(response["error"]).to eq(["not in your friends list"])
      end
    end

    context "have in friends list as" do
      post_id = 920
      it "post not exist" do
        response = get_request_with_auth(user , "/api/post/#{post_id}" )
        expect(response["status"]).to eq(404)
        expect(response["error"]).to eq(["post not found"])
      end

      it "in friend list" do
        post_id = 85
        response = get_request_with_auth(user , "/api/post/#{post_id}" )
        user = User.find_by(username: "test")
        post = Post.find_by(id:85)
        expect(user.followers.find_by(follow_by_id: post.user_id).present?).to eq(true)
        expect(response["status"]).to eq(200)
      end

      it "matches from database" do
        post_id = 85
        response = get_request_with_auth(user , "/api/post/#{post_id}" )
        post = Post.find_by(id:85)
        expect(response["status"]).to eq(200)
        expect(response["res"]["id"]).to eq(post.id)
        expect(response["res"]["caption"]).to eq(post.caption)
        expect(response["res"]["body"]).to eq(post.body)
      end
    end
  end


  describe "PUT /api/post/" do
    
    it "cannot access without authorized" do
      put "/api/post" , params: { post_id: 61 , action: "like"}
      json_body = JSON.parse(response.body)
      expect(json_body["status"]).to eq(401)
      expect(json_body["error"]).to eq(["unauthorized"])
    end

    context "valid for only values of action and post_id present is  " do
      post_id = 61
      it "like" do
        response = put_request_with_auth(user , "/api/post" , {  post_id: post_id , action: "like"} )
        expect(response["status"]).to eq(200)
      end

      it "dislike" do
        response = put_request_with_auth(user , "/api/post" , {  post_id: post_id,action: "dislike"} )
        expect(response["status"]).to eq(200)
      end
    end

    it "not valid if post_id is missing" do
      response = put_request_with_auth(user , "/api/post" , { action: "dislike"} )
      expect(response["error"]).to eq(["postId is missing"])
    end

    it "not valid for action values other than [like, dislike]" do
        response = put_request_with_auth(user , "/api/post" , { post_id: 61 ,  action: "other"} )
        expect(response["error"]).to eq("action does not have a valid value")
    end


    context do
      post_id = "987"

      it "if post not exist [database check]" do
        put_request_with_auth(user , "/api/post/#{post_id}" , { action: "like"} )
        post = Post.find_by(id: post_id)
        expect(post.present?).to eq(false)
      end

      it "if post not exist [response msg check]" do
        response = get_request_with_auth(user , "/api/post/#{post_id}" )
        expect(response["status"]).to eq(404)
        expect(response["error"]).to eq(["post not found"])
      end
    end
    
    context "not have connection(follower or following)" do
      post_id = 3
      it "post not exist " do
        response = put_request_with_auth(user , "/api/post" , { post_id: post_id ,  action: "like"} )
        expect(response["status"]).to eq(404)
        expect(response["error"]).to eq(["post not found"])
      end
      
      it "not in follower and following list" do
        post_id = 78
        response = put_request_with_auth(user , "/api/post" , { post_id: post_id ,  action: "like"} )
        expect(response["status"]).to eq(403)
        expect(response["error"]).to eq(["not in your friends list"])
      end
    end

    context "have in friends list as" do
      post_id = 920
      it "post not exist" do
        response = put_request_with_auth(user , "/api/post" , { post_id: post_id ,  action: "like"} )
        expect(response["status"]).to eq(404)
        expect(response["error"]).to eq(["post not found"])
      end
      context do
      post_id = 85
      it "in friend list" do
        put_request_with_auth(user , "/api/post" , { post_id: post_id ,  action: "like"} )
        user = User.find_by(username: "test")
        post = Post.find_by(id:85)
        expect(user.followers.find_by(follow_by_id: post.user_id).present?).to eq(true)
      end
      
      it "like action" do
        prev = Post.find_by(id: post_id)
        put_request_with_auth(user , "/api/post" , { post_id: post_id ,  action: "like"} )
        post = Post.find_by(id: post_id)
        excpect(post.likes).to eq(prev.likes+1)
      end
      
      it "dislike action" do
        prev = Post.find_by(id: post_id)
        put_request_with_auth(user , "/api/post" , { post_id: post_id ,  action: "dislike"} )
        post = Post.find_by(id: post_id)
        expect(post.dislikes).to eq(prev.dislikes+1)
      end
      end
    end
  end

  describe "DELETE /api/post/:postId" do
    baseUrl = "/api/post"

    it "cannot access without authorized" do
      delete "#{baseUrl}/90" 
      json_body = JSON.parse(response.body)
      expect(json_body["status"]).to eq(401)
      expect(json_body["error"]).to eq(["unauthorized"])
    end

    
    it "database validation" do
      post_id = 82
      user = User.find_by(id: user.id)
      prev = user.posts.length
      res = delete_request_with_auth(user , "#{baseurl}/#{post_id}") 
      post = Post.find_by(id: post_id)
      expect(post.present?).to eq(false)
      expect(user.posts.length).to eq(prev-1)
      expect(res["status"]).to eq(200)
    end

  end



end
