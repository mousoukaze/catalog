class ProductsController < ApplicationController
  http_basic_authenticate_with name: "admin", password: "password"

  def index
    @products = Product.paginate(page: params[:page], per_page: 5)
  end

  def new
    @product = Product.new
    @categories = Category.all
    @selected = nil
  end

  def create
    @categories = Category.all
    @category = Category.find(product_params[:category])
    @product = Product.new(name: product_params[:name])
    @product.category_id = @category.id

    if @product.save
      redirect_to products_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @product = Product.find(params[:id])
    @categories = Category.all
    @selected = nil
    unless @product.category.nil?
      @selected = @product.category.id
    end
  end

  def update
    @category = Category.find(product_params[:category])
    @product = Product.find(params[:id])
    @product.category_id = @category.id

    if @product.save
      redirect_to products_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @product = Product.find(params[:id])
    @product.destroy

    redirect_back(fallback_location: products_path)
  end

  private
    def product_params
      params.require(:product).permit(:name, :category)
    end

end
