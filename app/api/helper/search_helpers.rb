module Helper
  module SearchHelpers  
  
    def search_users(query,pageNo,limit,sortType)
      pageNo = 1 if pageNo.nil? 
      limit = 10 if limit.nil?
      if pageNo <= 0
        err_msg = "Invalid page no"
        raise Exceptions::PaginationExceptions::InvalidPageNo.new([err_msg]), err_msg
      end
      query = "%#{query}%"
      case sortType
      when "date"
        # User.search_user(query).offset((pageNo-1)*limit).limit(limit).order(created_at: :desc)
        res = User.select("users.*, COUNT(*) OVER () as total").where("first_name ILIKE ? OR last_name ILIKE ? OR username ILIKE ?",
                  query,query,query).offset((pageNo-1)*limit).limit(limit).order(created_at: :desc)
      else 
        # User.search_user(query).offset((pageNo-1)*limit).limit(limit).order(created_at: :desc)
        res = User.select("users.*, COUNT(*) OVER () as total").where("first_name ILIKE ? OR last_name ILIKE ? OR username ILIKE ?",
                  query,query,query).offset((pageNo-1)*limit).limit(limit).order(created_at: :desc)
      end

      if res.length == 0
        return { res: res , 
                  totalPage: 0 ,
                   currentPage: pageNo }
      end
      totalPage = (res.first.try(:total)/limit) + 1
      if pageNo > totalPage
        raise Exceptions::PaginationExceptions::InvalidPageNo.new(["invalid page"]),"invalid page"
      end
      { res: res , totalPage: totalPage , currentPage: pageNo }
    rescue Exceptions::PaginationExceptions::InvalidPageNo => e
      error(e.errors,403)
    end

    def outputGenerate(output , with)
      res = { :status => 200,
              :res => output
            }
      present res , with: with
    end

    def benchmark
        start_time = Time.current
        yield
        end_time = Time.current
        File.open("benchmark","a+") do |file|
          file.puts("#{end_time-start_time}sec")
        end
    end

  end
end

 
