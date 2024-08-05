module Helper
  module ResponseHelpers
    def generate_response(model , presenter)
      present :status , 200
      present :res , model , with: presenter
    end
  end
end
 
