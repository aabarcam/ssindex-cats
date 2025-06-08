class CatFactsController < ApplicationController
  def index
    facts = CatFactsService.new.get_page(params[:page])
    data = facts["data"]
    @cat_facts = data.map { |element| element["fact"] }
  end
end
