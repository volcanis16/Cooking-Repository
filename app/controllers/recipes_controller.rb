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
        cleanup()
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
    if recipe_params[:notes_only].to_i == 1
      @recipe = Recipe.update_notes(@recipe, recipe_params)
    else
      @recipe = Recipe.update_data(@recipe, recipe_params)
      #Split and assign tags and categories
      @recipe.tags_full_list=(params[:tags])
      @recipe.categories_full_list=(params[:categories])
    end
    respond_to do |format|
      if @recipe.save
        cleanup()
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

  #Checks list vs existing tags/categories and returns the ones that don't already exist
  def check_tags
    new_tags = ""

    tags = split_and_strip(params[:tags], ",")
    categories = split_and_strip(params[:categories], ",")

    names = Tag.pluck(:name)
    tags.each { |t| new_tags += ", #{t}" unless names.include?(t) }

    names = Category.pluck(:name)
    categories.each { |c| new_tags += ", #{c}" unless names.include?(c) }

    new_tags.slice!(0..1) unless new_tags.blank?
    respond_to do |format|
      format.json {render :json => {list: new_tags}, :status => 200 }
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
      params.require(:recipe).permit(:notes_only, :main_image , :title, :description, :notes, :default_servings,
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
        unless Category.order(Arel.sql('RANDOM()')).first.blank? 
          options.random_category = Category.order(Arel.sql('RANDOM()')).first.id
        end 
        options.save
      end
    end

    # Test and destroy tags and categories without recipes
    def cleanup
      Tag.all.each do |t|
        t.destroy if t.recipes.blank?
      end

      Category.all.each do |c|
        c.destroy if c.recipes.blank?
      end

    end
end
