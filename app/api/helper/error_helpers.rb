module Helper
  module ErrorHelpers
   
    def unauthorized_error! 
      error!('Unauthorized',401)
    end

    def not_have_connection!
      error!('not in your friends list',403)
    end
    
    def post_not_found!
      error!('post not found',403)
    end

  end
end
 
