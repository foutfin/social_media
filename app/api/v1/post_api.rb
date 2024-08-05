module V1
  class PostApi < Grape::API
    helpers Helper::PostHelpers
    helpers Helper::AuthHelpers
    helpers Helper::ResponseHelpers

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
        post_id = create_new_post(@current_user,params[:caption],
                            params[:body] ,params[:media])
        { :status => 200 , :post_id => post_id }
      end

      get  do
        posts = get_all_posts @current_user
        generate_response(posts,Entities::Post)
      end
      
      params do
        requires :post_id , type: Integer
      end
      put "archive" do
        archive_post @current_user , params[:post_id]
        { :status => 200 , :msg => "ok"}
      end

      namespace  do
        before do
          check_connection params[:post_id]
        end

        namespace :action do

          params do
            requires :post_id , type: Integer
            requires :action , type: String , values:['like' , 'dislike']
          end
          put  do
            pp "userId got #{params[:post_id]}"
            handle_action @current_user, params[:action] , params[:post_id]
            { :status => 200 , :msg => "ok"}
          end

        end

        get "/:post_id" do
          generate_response(@post,Entities::Post)
        end

        

      end

    end
  end
end
