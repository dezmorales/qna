class SearchController < ApplicationController
  skip_authorization_check

  def index
    @result = SearchService.new(params[:query], params[:scope]).call
  end
end
