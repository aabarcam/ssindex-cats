class LikesController < ApplicationController
  protect_from_forgery with: :null_session

  def create
    fact_id = params[:fact_id]
    @user.user_likes_cat_facts.create(fact_id: fact_id)
    render json: { data: { fact_id: fact_id } }, status: :ok
  end

  def index
    liked_facts = @user.user_likes_cat_facts.all
    liked_ids = liked_facts.map { |fact| fact.fact_id }
    @likes = CatFactsService.new.get_facts liked_ids
    render json: { likes: @likes }, status: :ok
  end

  def destroy
    fact_id = params[:fact_id]
    fact = @user.user_likes_cat_facts.find_by(fact_id: fact_id)
    if fact != nil
      fact.destroy
      render json: { data: { fact_id: fact_id } }, status: :ok
    else
      render json: { message: "Invalid fact ID" }, status: :not_found
    end
  end
end
