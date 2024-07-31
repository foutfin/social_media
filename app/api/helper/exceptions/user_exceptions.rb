module Exceptions
  module UserExceptions

    class InvalidUser < BaseException
    end

    class InvalidFollowRequest < BaseException
    end
    
    class UserNotFound  < BaseException
    end
    
    class ConnectionNotFound < BaseException
    end
    
  end
end
