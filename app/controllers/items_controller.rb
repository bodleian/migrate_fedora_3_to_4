class ItemsController < ApplicationController
  
  def index
    @items = object_model ? object_model.items : Item.all
  end

  def show
    @item = Item.find(params[:id])
  end
  
  private
  def object_model
    return unless params[:object_model_id]
    @object_model ||= ObjectModel.find(params[:object_model_id])
  end
  
end
