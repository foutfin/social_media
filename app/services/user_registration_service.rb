class UserRegistrationService
  attr_reader :errors

  def initialize(first_name,last_name,email,username,bio,
                  password) 
    @first_name = first_name
    @last_name = last_name 
    @email = email
    @username = username
    @bio = bio
    @password = password
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
    if !user.save
      @errors = user.errors.full_messages
      raise "Unable to create new user"
    end

  end
end
