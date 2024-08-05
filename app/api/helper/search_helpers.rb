module Helper
  module SearchHelpers  
  
    def search_users(query,pageNo,limit)
      pageNo = 1 if pageNo.nil? 
      limit = 10 if limit.nil?
      if pageNo <= 0
        err_msg = "Invalid page no"
        raise Exceptions::PaginationExceptions::InvalidPageNo.new([err_msg]), err_msg
      end
      query = "%#{query}%"
      User.where("first_name LIKE ? OR last_name LIKE ? OR username LIKE ?",
                  query,query,query).offset((pageNo-1)*limit).limit(limit)
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
 
