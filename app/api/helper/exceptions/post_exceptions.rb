module Helper
module Exceptions
  module PostExceptions
    class BaseException < RuntimeError
      attr :errors
      def initialize(errors)
        @errors = errors
      end
    end

    class InvalidPost < BaseException
    end
    
    class MediaNotAbleToUpload < BaseException
    end
    
    class S3Unavailable < BaseException
    end
    
    class PostNotFound < BaseException
    end
    
    class UserNotFound < BaseException
    end

  end
end
end
