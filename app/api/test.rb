module Test
  class API < Grape::API
    format :json

    resource :statuses do 
      get :ping do
        { :msg => "pong"}
      end
    end
  end
end

