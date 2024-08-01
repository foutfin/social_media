module Helper
module Exceptions
  module PaginationExceptions
    class BaseException < RuntimeError
      attr :errors
      def initialize(errors)
        @errors = errors
      end
    end

    class InvalidPageNo < BaseException
    end

  end
end
end
