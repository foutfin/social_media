class BaseException < RuntimeError
  attr :errors
  def initialize(errors)
    @errors = errors
  end
end

