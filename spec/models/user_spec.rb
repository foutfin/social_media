require 'rails_helper'

RSpec.describe User, type: :model do
  it "is valid with valid attributes" do
    user = User.new(
      first_name:"test",
      last_name:"test",
      username:"tests",
      password:"1234567",
      password_confirmation:"1234567",
      email:"abc@abc.com"
    )
    expect(user).to be_valid
  end
  it "is not valid without email" do
    user = User.new(
      first_name:"test",
      last_name:"test",
      username:"tests",
      password:"1234567",
      password_confirmation:"1234567",
    )
    expect(user).to_not be_valid
  end
  it "is not valid without first_name" do
    user = User.new(
      last_name:"test",
      username:"tests",
      password:"1234567",
      password_confirmation:"1234567",
      email:"abc@abc.com"
    )
    expect(user).to_not be_valid
  end
  it "is not valid without last_name" do
    user = User.new(
      first_name:"test",
      username:"tests",
      password:"1234567",
      password_confirmation:"1234567",
      email:"abc@abc.com"
    )
    expect(user).to_not be_valid
  end
  it "is not valid for wronge email" do
    user = User.new(
      first_name:"test",
      last_name:"test",
      username:"tests",
      password:"1234567",
      password_confirmation:"1234567",
      email:"abc"
    )
    expect(user).to_not be_valid
  end

  it "is  valid for correct email" do
    user = User.new(
      first_name:"test",
      last_name:"test",
      username:"tests",
      password:"1234567",
      password_confirmation:"1234567",
      email:"abcdef@abc.com"
    )
    expect(user).to be_valid
  end
  it "is not valid for email greater than 255" do 
    user = User.new(
      first_name:"test",
      last_name:"test",
      username:"tests",
      password:"1234567",
      password_confirmation:"1234567",
      email:"#{"a"*246}@gmail.com"
    )
    expect(user).to_not be_valid
  end
  it "is  valid for email within limit 255" do
    user = User.new(
      first_name:"test",
      last_name:"test",
      username:"tests",
      password:"1234567",
      password_confirmation:"1234567",
      email:"#{"a"*226}@gmail.com"
    )
    expect(user).to be_valid
  end
  it "is not valid for first_name greater than 50" do
    user = User.new(
      first_name:"#{"t"*51}",
      last_name:"test",
      username:"tests",
      password:"1234567",
      password_confirmation:"1234567",
      email:"abdc@gmail.com"
    )
    expect(user).to_not be_valid
  end
  it "is  valid for first_name within limit 50" do
    user = User.new(
      first_name:"#{"t"*20}",
      last_name:"test",
      username:"tests",
      password:"1234567",
      password_confirmation:"1234567",
      email:"abdc@gmail.com"
    )
    expect(user).to be_valid
  end
  it "is not valid for last_name greater than 50" do 
    user = User.new(
      first_name:"#{"t"*12}",
      last_name:"#{"a"*52}",
      username:"tests",
      password:"1234567",
      password_confirmation:"1234567",
      email:"abdc@gmail.com"
    )
    expect(user).to_not be_valid
  end
  it "is  valid for last_name within limit 50" do
    user = User.new(
      first_name:"#{"t"*12}",
      last_name:"#{"a"*25}",
      username:"tests",
      password:"1234567",
      password_confirmation:"1234567",
      email:"abdc@gmail.com"
    )
    expect(user).to be_valid
  end
  it "is not valid for password less than 6 charcters" do
    user = User.new(
      first_name:"#{"t"*12}",
      last_name:"#{"a"*12}",
      username:"tests",
      password:"123",
      password_confirmation:"123",
      email:"abdc@gmail.com"
    )
    expect(user).to_not be_valid
  end
  it "is  valid for password greater and equal to 6 charcters" do
    user = User.new(
      first_name:"#{"t"*12}",
      last_name:"#{"a"*12}",
      username:"tests",
      password:"12345678",
      password_confirmation:"12345678",
      email:"abdc@gmail.com"
    )
    expect(user).to be_valid
  end

  it " is valid if password and password_confirmation matches" do
    user = User.new(
      first_name:"#{"t"*12}",
      last_name:"#{"a"*12}",
      username:"tests",
      password:"other@345",
      password_confirmation:"other@345",
      email:"abdc@gmail.com"
    )
    expect(user).to be_valid
  end
  it " is not valid if password and password_confirmation matches" do
    user = User.new(
      first_name:"#{"t"*12}",
      last_name:"#{"a"*12}",
      username:"tests",
      password:"other@345",
      password_confirmation:"oer@345",
      email:"abdc@gmail.com"
    )
    expect(user).to_not be_valid
  end


  it { expect(described_class.reflect_on_association(:posts).macro).to eq(:has_many) } 
  it { expect(described_class.reflect_on_association(:followers).macro).to eq(:has_many) } 
  it { expect(described_class.reflect_on_association(:following).macro).to eq(:has_many) } 
  it { expect(described_class.reflect_on_association(:follow_requests).macro).to eq(:has_many) } 
  it { expect(described_class.reflect_on_association(:followed_posts).macro).to eq(:has_many) } 
  it { expect(described_class.reflect_on_association(:history).macro).to eq(:has_many) } 

end
