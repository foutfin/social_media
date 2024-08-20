module Helper
  module CacheHelpers  
    
    def find(key)
       Rails.cache.read(key)
    end

    def write(key,value)
      Rails.cache.write(key, value)
    end
    
    def get_user_cache(key)
      user = find(key)
      if user.nil?
        user = User.find_by(jti: jti) 
        if user.present? 
          write(user.jti , user)
        end
      end
      return user
    end

    def get_cache_filter(id ,filter,p,limit)
      result = find("#{id}-#{filter}-#{limit}")
      if result.nil?
        return nil  
      end
      if result["#{p}"].nil?
        return nil
      end
      result["#{p}"]
    end

    def get_cache(key)
      result = find(key)
      if result.nil?
        return nil  
      end
      result
    end

    def invalidate_cache(key)
      Rails.cache.delete(key)
    end

    def invalidate_post_filter_cache(key)
      invalidate_cache "#{key}-all-10"
      invalidate_cache "#{key}-media-10"
      invalidate_cache "#{key}-text-10"
    end

    def invalidate_followrequest_cache(key)
      invalidate_cache "#{key}-pending"
      invalidate_cache "#{key}-rejected"
    end

  end
end


 
