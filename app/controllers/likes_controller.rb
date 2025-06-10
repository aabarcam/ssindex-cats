class LikesController < ApplicationController
  def create
    fact_id = params[:fact_id]
    user = Current.user
    user.user_likes_cat_facts.create(fact_id: fact_id)
    redirect_back_or_to root_url
  end

  def index
    user = Current.user
    liked_facts = user.user_likes_cat_facts.all
    liked_ids = liked_facts.map { |fact| fact.fact_id }
    @likes = CatFactsService.new.get_facts liked_ids
  end

  def destroy
    fact_id = params[:fact_id]
    user = Current.user
    fact = user.user_likes_cat_facts.find_by(fact_id: fact_id)
    if fact != nil
      fact.destroy
      redirect_back_or_to root_url
    else
      render file: "#{Rails.root}/public/400.html", layout: false, status: :not_found
    end
  end
end
