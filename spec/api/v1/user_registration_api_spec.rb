require 'rails_helper'

RSpec.describe "V1::UserRegistrationApi" , '/user/register' do

  let(:register_endpoint) { "/user/register" }
  let(:user)  { { first_name: "test",last_name: "test", username: "test",email: "test@abc.com", password: "1234567" } }
  
  context "with all required fields(first_name , last_name , username, email , password)" do
    it 'creates a new user' do
      expect do
        post "/user/register" , params: user
      end.to change(User,:count).by 1
    end

    it 'responses for new user created' do
      post "/user/register" , params: user
      json_body = JSON.parse(response.body)
      expect(json_body["msg"]).to  eq("User Created Successfully")
      expect(json_body["status"]).to eq(200)
    end

  end

  context "not valid if field " do
    it 'email in wrong format' do
      user["email"] = "abc"
      post "/user/register" , params: user
      json_body = JSON.parse(response.body)
      # byebug
      expect(json_body["error"]).to eq("email is invalid")
    end

    it 'email not present' do
      user["email"] = nil
      post "/user/register" , params: user
      json_body = JSON.parse(response.body)
      expect(json_body["err"].length).to eq(2)
      expect(json_body["err"]).to eq(["Email can't be blank" , "Email is invalid"])
    end

    it 'first_name not present' do
      user["first_name"] = nil
      post "/user/register" , params: user
      json_body = JSON.parse(response.body)
      expect(json_body["err"].length).to eq(1)
      expect(json_body["err"]).to eq(["First name can't be blank" ])
    end

    it 'last_name not present' do
      user["last_name"] = nil
      post "/user/register" , params: user
      json_body = JSON.parse(response.body)
      expect(json_body["err"].length).to eq(1)
      expect(json_body["err"]).to eq(["Last name can't be blank"])
    end

    it 'username not present' do
      user["username"] = nil
      post "/user/register" , params: user
      json_body = JSON.parse(response.body)
      expect(json_body["err"].length).to eq(1)
      expect(json_body["err"]).to eq(["Username can't be blank"])
    end
    
    it 'password not present' do
      user["password"] = nil
      post "/user/register" , params: user
      json_body = JSON.parse(response.body)
      expect(json_body["err"].length).to eq(2)
      expect(json_body["err"]).to eq(["Password can't be blank" , "Password is too short (minimum is 6 characters)"])
    end


  end
end
