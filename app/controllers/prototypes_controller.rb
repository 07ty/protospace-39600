class PrototypesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show, :new]
  def show
    @prototype = Prototype.find(params[:id])
    @comment = Comment.new
    @comments = @prototype.comments.includes(:user)
  end

  def index
    @prototypes = Prototype.includes(:user)
  end

  def new
    @prototype = Prototype.new
  end
    
  def create
    @prototype = current_user.prototypes.new(prototype_params)
    if @prototype.save
      redirect_to prototype_path(@prototype), notice: 'プロトタイプが作成されました。'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @prototype = Prototype.find(params[:id])
    @prototype.destroy
    redirect_to root_path
  end
    
  def edit
    @prototype = Prototype.find(params[:id])
  end
      
  def update
    @prototype = Prototype.find(params[:id])
    if @prototype.update(prototype_params)
      redirect_to root_path
    else
      puts @prototype.errors.full_messages # バリデーションエラーメッセージを表示
      render :edit, status: :unprocessable_entity
    end
  end

  private
    
  def prototype_params
    params.require(:prototype).permit(:title, :catch_copy, :concept, :image)
  end
    
    def move_to_index
    access_prototype = Prototype.find(params[:id])
    unless user_signed_in? && access_prototype.user == current_user
    redirect_to action: :index
    end
  end
end

