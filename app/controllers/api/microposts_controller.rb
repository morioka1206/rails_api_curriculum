class Api::MicropostsController < ApplicationController
  before_action: authenticate, only %i[create]

  def index
    microposts = Micropost.includes(:user)
    render json: microposts, each_serializer: MicropostSerializer
  end

  def create
    micropost = current_user.microposts.create!(micropost_params)
    render json: micropost, serializer: MicropostSerializer, status: :created
  end

  def update

  end

  def destroy

  end

  private

  def micropost_params
    params.require(:micropost).permit(:content)
  end
end
