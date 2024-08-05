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
      @token , _ = Warden::JWTAuth::UserEncoder.new.call(user,:user ,nil)
    user.save
    else
      @errors = ["user not found"]
      raise "user not found"
    end
  end

  def logout
  end

end
