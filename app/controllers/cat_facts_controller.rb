class CatFactsController < ApplicationController
  def index
    begin
      data = CatFactsService.new.get_page(params[:page])
      facts_array = CatFactsService.new.attach_id_to_fact(data[:data], 
                                                          data[:current_page], 
                                                          data[:per_page])
      fact_hash = { facts: facts_array,
                    current_page: data[:current_page],
                    last_page: data[:last_page] }
      @cat_facts = fact_hash
    rescue BadHttpCallError, RequestedPageDoesNotExist
      redirect_to cat_facts_index_url
    end
  end
end
