module Helper
  module SearchHelpers  
  
    def search_users(query,pageNo)
      pageNo = 1 if pageNo.nil? 
      pp "Page No:- #{pageNo}"
      if pageNo <= 0
        err_msg = "Invalid page no"
        raise Exceptions::PaginationExceptions::InvalidPageNo.new([err_msg]), err_msg
      end
      records_per_page = 10
      query = "%#{query}%"
      FollowJob.perform_async('arg-0')
      User.where("first_name LIKE ? OR last_name LIKE ? OR username LIKE ?",
                  query,query,query).offset((pageNo-1)*records_per_page).limit(records_per_page)
    end

  end
end
 
