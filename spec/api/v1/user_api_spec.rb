require 'rails_helper'

RSpec.describe "V1::PostApi" , '/api/post' do

  let(:user) {{ username: "test" , password: "1234567" }}
 
  describe "GET /api/me" do

    it "cannot access without authorized" do
      get "/api/user/me"
      json_body = JSON.parse(response.body)
      expect(json_body["status"]).to eq(401)
      expect(json_body["error"]).to eq(["unauthorized"])
    end

    it "valid if matches with database record" do
      res = get_request_auth(user , "/api/user/me" )
      user = User.find_by(username: "test")
      expect(res["status"]).to eq(200)
      expect(res["res"]["user_id"]).to eq(user.id)
      expect(res["res"]["first_name"]).to eq(user.first_name)
      expect(res["res"]["last_name"]).to eq(user.last_name)
      expect(res["res"]["bio"]).to eq(user.bio)
      expect(res["res"]["email"]).to eq(user.email)
    end

  end

  describe "GET /api/user/followrequets?status=<status>" do
    baseUrl = "/api/user/followrequests"

    it "cannot access without authorized" do
      get "#{baseUrl}?status=pending"
      json_body = JSON.parse(response.body)
      expect(json_body["status"]).to eq(401)
      expect(json_body["error"]).to eq(["unauthorized"])
    end

    it "not valid status" do
      res = get_request_auth(user,"#{baseUrl}?status=other")
      expect(res["error"]).to eq("status does not have a valid value")
    end
    
    context "valid if status value is " do
      it "pending" do
        res = get_request_auth(user,"#{baseUrl}?status=pending")
        user = user.find_by(username: user.username)
        expect(res["status"]).to eq(200)
        expect(res["res"].length).to eq(user.follow_requests.pending.length)
      end

      it "rejected" do
        res = get_request_auth(user,"#{baseUrl}?status=rejected")
        user = user.find_by(username: user.username)
        expect(res["res"].length).to eq(user.follow_requests.rejected.length)
      end

      it "no status value is given " do
        res = get_request_auth(user,"#{baseUrl}")
        user = user.find_by(username: user.username)
        expect(res["res"].length).to eq(user.follow_requests.pending.length)
      end
    end

  end

  describe "GET /api/user/followers" do
    baseUrl = "/api/user/followres"

    it "cannot access without authorized" do
      get "#{baseUrl}"
      json_body = JSON.parse(response.body)
      expect(json_body["status"]).to eq(401)
      expect(json_body["error"]).to eq(["unauthorized"])
    end

    it "should matches with the database record" do
      res = get_request_auth(user,"#{baseUrl}")
      user = user.find_by(username: user.username)
      expect(res["res"].length).to eq(user.followers.length)
    end

  end

  describe "GET /api/user/following" do
    baseUrl = "/api/user/following"

    it "cannot access without authorized" do
      get "#{baseUrl}"
      json_body = JSON.parse(response.body)
      expect(json_body["status"]).to eq(401)
      expect(json_body["error"]).to eq(["unauthorized"])
    end

    it "should matches with the database record" do
      res = get_request_auth(user,"#{baseUrl}")
      user = user.find_by(username: user.username)
      expect(res["res"].length).to eq(user.followers.length)
    end

  end

  describe "GET /api/user/:userId" do
    baseUrl = "/api/user"
    other_user_id = 62

    it "cannot access without authorized" do
      get "#{baseUrl}/#{other_user_id}"
      json_body = JSON.parse(response.body)
      expect(json_body["status"]).to eq(401)
      expect(json_body["error"]).to eq(["unauthorized"])
    end

    it "user not found" do
      res = get_request_auth(user,"#{baseUrl}/#{other_user_id}")
      expect(res["error"]).to eq(["user not found"])
    end

    it "valid if matches with database record" do
      res = get_request_auth(user ,"#{baseUrl}/#{other_user_id}" )
      user = User.find_by(id: other_user_id)
      expect(res["status"]).to eq(200)
      expect(res["res"]["user_id"]).to eq(user.id)
      expect(res["res"]["first_name"]).to eq(user.first_name)
      expect(res["res"]["last_name"]).to eq(user.last_name)
      expect(res["res"]["bio"]).to eq(user.bio)
    end
  end


  describe "GET /api/user" do
    baseUrl = "/api/user"

    it "cannot access without authorized" do
      put "#{baseUrl}/#{other_user_id}"
      json_body = JSON.parse(response.body)
      expect(json_body["status"]).to eq(401)
      expect(json_body["error"]).to eq(["unauthorized"])
    end

    it "not valid if first_name , last_name , bio not provided" do
      res = put_request_auth(user,"#{baseUrl}", {})
      expect(res["error"]).to eq(["first_name, last_name, bio are missing, at least one parameter must be provided"])
    end

    context "valid if " do
      it "first_name given" do
        res = put_request_auth(user,"#{baseUrl}", { first_name: "changed"})
        user = User.find_by(id: other_user_id)
        expect(res["status"]).to eq(200)
        expect(user.first_name).to eq("changed")
      end
      
      it "last_name given" do
        res = put_request_auth(user,"#{baseUrl}", { last_name: "changed"})
        user = User.find_by(id: other_user_id)
        expect(res["status"]).to eq(200)
        expect(user.last_name).to eq("changed")
      end

      it "bio given" do
        res = put_request_auth(user,"#{baseUrl}", { bio: "changed"})
        user = User.find_by(id: other_user_id)
        expect(res["status"]).to eq(200)
        expect(user.bio).to eq("changed")
      end

      it "all given" do
        res = put_request_auth(user,"#{baseUrl}", { first_name: "changed" , last_name: "changed", bio: "changed"})
        user = User.find_by(id: other_user_id)
        expect(res["status"]).to eq(200)
        expect(user.first_name).to eq("changed")
        expect(user.last_name).to eq("changed")
        expect(user.bio).to eq("changed")
      end
    end

  end


  describe "POST /api/user/follow" do
    baseUrl = "/api/user/follow"
    other_user_id = 62

    it "cannot access without authorized" do
      post "#{baseUrl}" , params: { user_id: other_user_id }
      json_body = JSON.parse(response.body)
      expect(json_body["status"]).to eq(401)
      expect(json_body["error"]).to eq(["unauthorized"])
    end

    it "not valid other user not exist" do
      res = post_request_auth(user,"#{baseUrl}", { user_id: other_user_id })
      expect(res["error"]).to eq(["user not found"])
    end

    it "following already followed user" do
      res = post_request_auth(user,"#{baseUrl}",{ user_id: 61 })
      expect(res["status"]).to eq(403)
      expect(res["error"]).to eq(["already following"])
    end

    it "already send follow request" do
      res = post_request_auth(user,"#{baseUrl}",{ user_id: 62 })
      expect(res["error"]).to eq(["from to is taken"])
    end

    context "valid if " do
      it "user exist" do
        res = post_request_auth(user,"#{baseUrl}",{ user_id: other_user_id })
        f_req = FollowRequest.last
        expect(res["status"]).to eq(200)
        expect(res["res"]["request_id"]).to eq(f_req.id)
      end
    end

  end


  describe "POST /api/user/unfollow" do
    baseUrl = "/api/user/unfollow"
    other_user_id = 61

    it "cannot access without authorized" do
      post "#{baseUrl}" , params: { user_id: other_user_id }
      json_body = JSON.parse(response.body)
      expect(json_body["status"]).to eq(401)
      expect(json_body["error"]).to eq(["unauthorized"])
    end

    it "not valid other user not exist" do
      res = post_request_auth(user,"#{baseUrl}", { user_id: 23 })
      expect(res["error"]).to eq(["user not found"])
    end

    it "unfollowing user that not in following list" do
      res = post_request_auth(user,"#{baseUrl}",{ user_id: 62 })
      expect(res["status"]).to eq(403)
      expect(res["error"]).to eq(["not in your fried list"])
    end


    context "valid if " do
      it "user exist" do
        user = User.find_by(id: other_user_id)
        prev = user.following.length
        res = post_request_auth(user,"#{baseUrl}",{ user_id: other_user_id })
        expect(res["status"]).to eq(200)
        expect(user.following.length).to eq(prev-1)
      end
    end

  end


  describe "POST /api/user/followrequest" do
    baseUrl = "/api/user/followrequest"
    request_id = 61

    it "cannot access without authorized" do
      post "#{baseUrl}" , params: { request_id: request_id , accpet: false }
      json_body = JSON.parse(response.body)
      expect(json_body["status"]).to eq(401)
      expect(json_body["error"]).to eq(["unauthorized"])
    end

    context "not valid if" do
      it "both not provide" do
        res = post_request_auth(user,"#{baseUrl}", {})
        expect(res["error"]).to eq("request_id is missing, accept is missing")
      end

      it "request_id is missing" do
        res = post_request_auth(user,"#{baseUrl}", {accpet: true})
        expect(res["error"]).to eq("request_id is missing")
      end
      
      it "accept is missing" do
        res = post_request_auth(user,"#{baseUrl}", {request_id: request_id})
        expect(res["error"]).to eq("accept is missing")
      end

      it "request_id not exist" do
        res = post_request_auth(user,"#{baseUrl}", {request_id: 987 , accpet: true})
        expect(res["error"]).to eq(["follow request not found"])
        expect(res["status"]).to eq(404)
      end

    end

    context "valid if " do
      it "correct request_id provided" do
        res = post_request_auth(user,"#{baseUrl}", {request_id: request_id , accpet: true})
        expect(res["status"]).to eq(202)
      end

      it "if matches in database[dislike]" do
        post_request_auth(user,"#{baseUrl}", {request_id: request_id , accpet: false})
        req = FOllowRequest.find_by(id:request_id)
        expect(req.approved).to eq(false)
      end

      it "if matches in database[like]" do
        user = User.find_by(id: other_user_id)
        prev = user.following.length
        post_request_auth(user,"#{baseUrl}", {request_id: request_id , accpet: false})
        expect(user.following.length).to eq(prev+1)
      end
    end

  end


  describe "DELETE /api/user/me" do
    baseUrl = "/api/user/me"

    it "cannot access without authorized" do
      delete "#{baseUrl}" 
      json_body = JSON.parse(response.body)
      expect(json_body["status"]).to eq(401)
      expect(json_body["error"]).to eq(["unauthorized"])
    end
    
    it "database validation" do
      prevCount = User.count
      res = delete_request_with_auth(user , baseurl) 
      user = User.find_by(id: other_user_id)
      expect(user.present?).to eq(false)
      expect(User.count).to eq(prevCount-1)
      expect(res["status"]).to eq(200)
    end

  end

end
