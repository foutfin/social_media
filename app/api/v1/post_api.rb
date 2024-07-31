module V1
  class PostApi < Grape::API
    helpers Helper::PostHelpers
    helpers Helper::AuthHelpers

    namespace :post do
      
      before do
        authenticate
      end

      params do 
        requires :caption , type: String
        optional :body , type: String
        optional :media , type: File
        at_least_one_of :media, :body
      end
      
      post do
        begin
          create_new_post(@current_user,params[:caption],
                            params[:body] ,params[:media])
          { :status => 200 , :msg => "ok"}
        rescue => e
          { :status => 401 , :msg => e.errors} 
        end
      end

      get  do
        get_all_posts @current_user
      end
      
      params do
        requires :post_id , type: Integer
        requires :action , type: String , values:['archive']
      end
          
      put  do
        begin
          archive_post @current_user , params[:post_id]
          { :status => 200 , :msg => "ok"}
        rescue => e
          { :status => 401 , :msg => e.errors} 
        end
      end

      namespace  do
        before do
          check_connection params[:post_id].to_i
        end

        get "/:post_id" do
          {:status => 200 , :res => @post}
        end

        namespace :action do
          params do
            requires :post_id , type: Integer
            requires :action , type: String , values:['like' , 'dislike']
          end
          
          put do
            postId = params[:post_id]
            case params[:action]
            when "like"
              like_post @current_user,postId
            when "dislike"
              dislike_post @current_user,postId
            end
          end

        end

      end

    end
  end
end
