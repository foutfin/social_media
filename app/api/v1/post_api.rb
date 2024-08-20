module V1
  class PostApi < Grape::API
    helpers Helper::PostHelpers
    helpers Helper::AuthHelpers
    helpers Helper::CacheHelpers
    helpers Helper::ResponseHelpers

    namespace :post do
      
      before do
        authenticate
      end

      params do 
        requires :caption , type: String
        optional :body , type: String
        # optional :media, type: Array do
        #   requires :media, :type => File
        # end
        optional :media , type: File
        at_least_one_of :media, :body
      end
      post do
        post_id = create_new_post(@current_user,params[:caption],
                            params[:body] ,params[:media])
        { :status => 200 , :post_id => post_id }
      end

      params do
        optional :type , type: String , values: ["all","text","media","archive"]
        optional :limit , type: Integer
        optional :page , type: Integer
        optional :sortby , type: String , values:['date' , "like"]
      end
      get  do
        posts = get_all_posts @current_user , params[:page], 
                  params[:limit], params[:sortby] , params[:type]          
        generate_response_with_page(posts,Entities::Post)
      end

      params do
        requires :post_id , type: Integer
      end
      delete do
        delete_post @current_user , params[:post_id]
        { :status => 200 , :msg => "ok"}
      end

      params do
        requires :post_id , type: Integer
        optional :caption , type: String
        optional :body , type: String
        at_least_one_of :caption,:body
      end
      put do
        edit_post @current_user,params[:post_id],params[:caption],params[:body] 
        { :status => 200 , :msg => "ok" }
      end
      
      params do
        requires :post_id , type: Integer
      end
      put "archive" do
        archive_post @current_user , params[:post_id]
        { :status => 200 , :msg => "ok"}
      end

      params do
        requires :post_id , type: Integer
      end
      put "unarchive" do
        unarchive_post @current_user , params[:post_id]
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
