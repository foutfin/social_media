module AuthHelper
    def authenticate
        if session[:user_id]
          begin
            @current_user ||= User.find(session[:user_id])
          rescue
            redirect_to '/signup'
          end
        else
            redirect_to '/signup'
        end
    end

    def isLogIn
      @current_user ||= User.find_by(id: session[:user_id])
    end
end
