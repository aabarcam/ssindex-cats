class CatFactsController < ApplicationController
  def index
    facts = CatFacts.new.get_page(params[:page])
    data = facts["data"]
    @cat_facts = data.map { |element| element["fact"] }
  end
end
