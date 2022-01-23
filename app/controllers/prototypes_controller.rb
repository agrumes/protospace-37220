class PrototypesController < ApplicationController
  before_action :set_prototaype, only: [:edit, :show]
  before_action :authenticate_user!, only: [:new, :edit, :destroy]
  before_action :move_to_index, except: [:index, :show]

  def index
    @prototypes = Prototype.includes(:user)
  end

  def new
    @prototype = Prototype.new
  end

  def create
    @prototype = Prototype.new(prototype_params)
    if @prototype.save
      redirect_to root_path
    else
      @prototype = Prototype.new(prototype_params)
      render :new
    end
  end

  def show
    @comment = Comment.new
    @comments = @prototype.comments.includes(:user)
  end

  def edit
  end

  def update
    prototype = Prototype.find(params[:id])
    prototype.update(prototype_params)
    if prototype.save
      redirect_to prototype_path(prototype.id)
    else
      prototype.attributes = prototype_params
      redirect_to edit_prototype_path
    end
  end

  def destroy
    prototype = Prototype.find(params[:id])
    prototype.destroy
    redirect_to root_path
  end


  private
  def prototype_params
    params.require(:prototype).permit(:title, :catch_copy, :concept, :image,).merge(user_id: current_user.id)
  end

  def set_prototaype
    @prototype = Prototype.find(params[:id])
  end

  def move_to_index
    unless Prototype.find(params[:id]).user.id.to_i ==  current_user.id
      redirect_to action: :index
      #処理後、indexファイルへリダイレクトする。
    end
  end
end
