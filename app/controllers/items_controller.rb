class ItemsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with:  :render_not_found_response

  def index
    if params[:user_id]
      user = User.find(params[:user_id])
      items = user.items
    else
      items = Item.all
    end
    render json: items, include: :user
  end

  def show
    item = Item.find(params[:id])
    render json: item, include: :user
  end

  def create
    if params[:user_id]
      user = User.find(params[:user_id])
      item = user.items.create(user_params)
    else
      item = Item.create(user_params)
    end
    render json: item, status: :created
  end

  private 

  def user_params
    params.permit(:name, :description, :price)
  end

  def render_not_found_response
    render json: { error: "Item not found" }, status: :not_found
  end

end
