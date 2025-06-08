class CatFactsController < ApplicationController
  def index
    facts = CatFactsService.new.get_page(params[:page])
    data = facts[:data]
    @cat_facts = data.map { |element| element[:fact] }
    puts facts[:current_page]
    @current_page = facts[:current_page]
    @last_page = facts[:last_page]
  end
end
