class CategoriesController < ApplicationController
  http_basic_authenticate_with name: "admin", password: "password"

  def index
    @categories = Category.paginate(page: params[:page], per_page: 5)
  end

  def new
    @category = Category.new
    @categories = Category.all
  end

  def create
    @categories = Category.all
    c_params = category_params
    if c_params[:parent].empty?
      c_params[:parent] = nil
    end

    @category = Category.new(name: c_params[:name])
    @category.parent_id = c_params[:parent]

    if @category.save
      redirect_to categories_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
    def category_params
      params.require(:category).permit(:name, :parent)
    end
end
