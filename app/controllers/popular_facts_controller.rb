class PopularFactsController < ApplicationController
  protect_from_forgery with: :null_session

  def index
    popular_fact_count = UserLikesCatFact.
                      group(:fact_id).
                      order("COUNT(fact_id) DESC").
                      limit(10).count
    popular_fact_ids = popular_fact_count.keys
    facts = CatFactsService.new.get_facts popular_fact_ids
    facts.each { |fact| fact[:likes] = popular_fact_count[fact[:id]] }
    @popular_facts = facts.sort { |a, b| b[:likes] <=> a[:likes] }
    render json: { facts: @popular_facts }, status: :ok
  end
end
