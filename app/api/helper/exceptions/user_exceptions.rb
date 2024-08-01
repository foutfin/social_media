module Helper
module Exceptions
  module UserExceptions

    class BaseException < RuntimeError
      attr :errors
      def initialize(errors)
        @errors = errors
      end
    end
    
    class InvalidUser < BaseException
    end

    class InvalidFollowRequest < BaseException
    end

    class InvalidConnection < BaseException
    end
    
    class InvalidFollowRequest < BaseException
    end
    
    class UserNotFound  < BaseException
    end
    
    class ConnectionNotFound < BaseException
    end

    class FollowRequestNotFound < BaseException
    end
    
  end
end
end
