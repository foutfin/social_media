require 'rails_helper'

RSpec.describe "V1::UserSessionApi" , '/user/login' do

  let(:user)  { {  username: "test1" , password: "1234567" } }
  
  context "POST /user/login with all required fields(username, password)" do
    # it 'creates a new user' do
    #   expect do
    #     post "/user/login" , params: user
    #   end.to change(User,:count).by 1
    # end

    # it 'responses for new user created' do
    #   post "/user/register" , params: user
    #   json_body = JSON.parse(response.body)
    #   expect(json_body["msg"]).to  eq("User Created Successfully")
    #   expect(json_body["status"]).to eq(200)
    # end

  end

  context "not valid if field " do

    it 'username not present' do
      user["username"] = nil
      post "/user/login" , params: user
      json_body = JSON.parse(response.body)
      expect(json_body["err"].length).to eq(1)
      expect(json_body["err"]).to eq(["Username can't be blank"])
    end

    it 'password not present' do
      user["password"] = nil
      post "/user/register" , params: user
      json_body = JSON.parse(response.body)
      expect(json_body["err"].length).to eq(1)
      expect(json_body["err"]).to eq(["Password can't be blank"])
    end

  end
end
