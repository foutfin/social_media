module AuthHelper
    def authenticate
        if session[:user_id]
            @current_user ||= User.find_by(id: session[:user_id])
        else
            redirect_to '/signup'
        end
    end
end