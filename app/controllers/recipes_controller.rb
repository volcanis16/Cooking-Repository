class RecipesController < ApplicationController
  before_action :set_recipe, only: [:show, :edit, :update, :destroy]
  before_action :set_recipes_and_count, only: :index
  before_action :check_date, only: :index

  # GET /recipes
  # GET /recipes.json
  def index
    @random = Option.find(1).random_category
  end

  # GET /recipes/1
  # GET /recipes/1.json
  def show
  end

  # GET /recipes/new
  def new
    @recipe = Recipe.new
  end

  # GET /recipes/1/edit
  def edit
  end

  # POST /recipes
  # POST /recipes.json
  def create
    @recipe = Recipe.build_from_form(recipe_params)

    #Split and assign tags and categories
    @recipe.tags_full_list=(params[:tags])
    @recipe.categories_full_list=(params[:categories])

    respond_to do |format|
      if @recipe.save
        format.html { redirect_to @recipe, notice: 'Recipe was successfully created.' }
        format.json { render :show, status: :created, location: @recipe }
      else
        format.html { render :new }
        format.json { render json: @recipe.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /recipes/1
  # PATCH/PUT /recipes/1.json
  def update
    @recipe = Recipe.update_data(@recipe, recipe_params)
    #Split and assign tags and categories
    @recipe.tags_full_list=(params[:tags])
    @recipe.categories_full_list=(params[:categories])
    respond_to do |format|
      if @recipe.save
        format.html { redirect_to @recipe, notice: 'Recipe was successfully updated.' }
        format.json { render :show, status: :ok, location: @recipe }
      else
        format.html { render :edit }
        format.json { render json: @recipe.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /recipes/1
  # DELETE /recipes/1.json
  def destroy
    @recipe.destroy
    respond_to do |format|
      format.html { redirect_to recipes_url, notice: 'Recipe was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_recipe
      @recipe = Recipe.find(params[:id])
    end

    def set_recipes_and_count
      @recipes = Recipe.all
      @recipe_count = @recipes.count
    end

    # Only allow a list of trusted parameters through.
    def recipe_params
      params.require(:recipe).permit(:main_image, :title, :description, :notes, :default_servings,
          ingredients_attributes: [:id, :name, :_destroy, 
            ingredient_lists_attributes: [:id, :unit_id, :amount, :alt_unit_id, :alt_amount, :prep, :_destroy, 
              ]])
    end

    # Test date and update random category for Home Page 
    def check_date
      date = Date.today
      options = Option.find(1)
  
      if options.randomDate != date
        options.randomDate = date
        options.random_category = Category.order(Arel.sql('RANDOM()')).first.id
        options.save
      end
    end
end
