class ObjectModelsController < ApplicationController
  def index
    @object_models = ObjectModel.all
  end

  def show
    @object_model = ObjectModel.find(params[:id])
  end
end
