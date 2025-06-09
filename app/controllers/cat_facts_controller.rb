class CatFactsController < ApplicationController
  def index
    begin
      facts = CatFactsService.new.get_page(params[:page])
      data = facts[:data]
      @cat_facts = data.map { |element| element[:fact] }
      @page_size = facts[:per_page]
      @current_page = facts[:current_page]
      @last_page = facts[:last_page]
    rescue BadHttpCallError, RequestedPageDoesNotExist
      redirect_to cat_facts_index_url
    end
  end
end
