require 'rails_helper'

RSpec.describe Post, type: :model do
  user = User.new(
      first_name:"test",
      last_name:"test",
      username:"tests",
      password:"1234567",
      password_confirmation:"1234567",
      email:"abc@abc.com"
    )
  subject {
    described_class.new(caption: "Anything",
                        body: "Lorem ipsum",
                        user: user
                        )
  }
  it " is valid with valid attributes " do
    expect(subject).to be_valid
  end

  it " is not valid without a caption " do
    subject.caption = nil
    expect(subject).to_not be_valid
  end

  it " is not valid for caption greater than 255 " do
    subject.caption = "#{'e'*256}"
    expect(subject).to_not be_valid
  end

  it " is valid for caption less than 255 " do
    subject.caption = "#{'d'*234}"
    expect(subject).to be_valid
  end
  it " is not valid for unsupported media " do
    subject.media.attach(io: File.open("/home/nav/Downloads/book.pdf") , filename: 'file.pdf' , content_type: 'application/pdf')
    expect(subject).to_not be_valid
  end
  it "is valid for supported media types" do
    subject.media.attach(io: File.open("/home/nav/Pictures/images/pic.avif") , filename: 'pic.avif' , content_type: 'image/avif')
    expect(subject).to be_valid
  end
  
  it { expect(described_class.reflect_on_association(:user).macro).to eq(:belongs_to) } 
end
