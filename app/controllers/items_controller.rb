class ItemsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response

  # GET all user.items based on :id
  def index
    if params[:user_id]
      user = find_user
      items = user.items
    else
      items = Item.all
    end
    render json: items, include: :user
  end

  # GET show only based on :id
  def show
    item = find_item
    render json: item
  end
  
  # POST new item; grab userId, create using params permit
  def create 
    user = find_user
    item = user.items.create(item_params)
    render json: item, status: :created
  end


  private

  def find_item
    Item.find(params[:id])
  end

  def find_user
    User.find(params[:user_id])
  end

  def item_params
    params.permit(:name, :description, :price)
  end

  def render_not_found_response(exception)
    render json: { error: "#{exception.model} not found" }, status: :not_found
  end

end
