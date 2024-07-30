class UserSessionService
  attr_reader :token , :errors

  def initialize(username,password) 
    @username = username
    @password = password
    @errors = nil
  end

  def login
    user = User.find_by(username: @username )
    if user.present?
      @token , payload = Warden::JWTAuth::UserEncoder.new.call(user,:user ,nil)
      pp "Payload got #{payload}"
    user.save
    else
      @errors = user.errors.full_messages
      raise "user not found"
    end
  end

  def logout
  end

end
