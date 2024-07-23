class SearchController < ApplicationController
  include AuthHelper
  def search
    authenticate
    query = params[:query]
    if query != nil && query != ""
      @search_result = User.where("first_name LIKE ? OR last_name LIKE ? or username LIKE ?", "%#{query}%" , "%#{query}%" ,"%#{query}%")
    else
      @search_result = nil
    end
  end
end
