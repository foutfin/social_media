module Helper
  module ResponseHelpers
    def generate_response(model , presenter)
      present :status , 200
      present :res , model , with: presenter
    end

    def generate_response_with_page(res,presenter )
      generate_response(res[:res],presenter)
      present :total_page , res[:totalPage]
      present :current_page , res[:currentPage]
    end

    def generate_response_user(res,presenter )
      generate_response(res[:res],presenter)
      present :isFriend , res[:isFriend]
    end
  end
end
 
