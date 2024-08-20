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
      if user.valid_password?(@password)
        @token , _ = Warden::JWTAuth::UserEncoder.new.call(user,:user ,nil)
        user.save
        Rails.cache.write(user.jti,user)
      else
        @errors = ["password does not match"]
        raise "password does not match"
      end
      
    else
      @errors = ["user not found"]
      raise "user not found"
    end
  end

end
