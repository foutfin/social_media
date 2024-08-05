module Helper
  module ErrorHelpers
    def error(error_msg, status)
      err_msg = { :status => status,
                  :error => error_msg  
                }
      error!(err_msg,status)
    end

    def unauthorized_error!
      error(['unauthorized'],401)
    end

    def not_have_connection!
      error(['not in your friends list'],403)
    end
    
    def post_not_found!
      error(["post not found"],404)
    end

    def user_not_found!
      error(["user not found"],404)
    end
    
    def follow_request_not_found!
      error(["follow request not found"],404)
    end

    def already_friend!
      error(["already following"],403)
    end

    def already_rejected!
      error(["already rejected"],403)
    end

  end
end
 
