class UserRegistrationService
  attr_reader :errors

  def initialize(first_name,last_name,email,username,bio,
                  password,avatar) 
    @first_name = first_name
    @last_name = last_name 
    @email = email
    @username = username
    @bio = bio
    @password = password
    @avatar = avatar
    @errors = nil
  end

  def register
    user = User.new(
              first_name: @first_name,
              last_name: @last_name,
              email: @email,
              username: @username,
              bio: @bio,
              password: @password,
            )
    pp "avatar got #{@avatar}"
    if !@avatar.nil? && !user.avatar.attach(io: @avatar["tempfile"] , filename: @avatar["filename"] )
      pp "run inside"
      @errors = ["invalid file"]

      raise "Unable to upload"
    end

    if user.save
      user.id
    else
      @errors = user.errors.full_messages
      raise "Unable to create new user"
    end

  end
end
