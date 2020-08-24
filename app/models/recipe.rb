class Recipe < ApplicationRecord
  #Build new Recipe
  def self.build_from_form(prm)
    recipe = Recipe.new(title: prm[:title], description: prm[:description], notes: prm[:notes], 
                          default_servings: prm[:default_servings])

    #Remove whitespace from beginning and end
    recipe.title = strip_whitespace(recipe.title)

    #Initialize ingredients and add ingredient_list relations and info
    recipe = initialize_ingredients(recipe, prm)
  end

  def self.update_data(recipe, prm)
    recipe.assign_attributes(title: prm[:title], description: prm[:description], notes: prm[:notes], 
                          default_servings: prm[:default_servings])
    recipe.title = strip_whitespace(recipe.title)
    recipe.ingredients.clear
    recipe = initialize_ingredients(recipe, prm)
  end

  def self.initialize_ingredients(recipe, prm)
    prm[:ingredients_attributes].each do |key, value|
      unless value[:_destroy] == '1'
        sleep(0.001)
        ingredient = Ingredient.where(name: value[:name]).first_or_initialize(id: (Time.now.to_f * 1000).to_i)
        ingredient.name = strip_whitespace(ingredient.name)
        recipe.ingredients << ingredient
        ingredient_list = recipe.ingredient_lists.last
        ingredient_list.fill_data(value[:ingredient_lists_attributes]['0'], ingredient.id)
      end
    end

    recipe
  end

  def tags_full_list
    self.tags.all.map { |t| t.name }.join(', ')
  end

  def tags_full_list=(tags)
    split = tags.split(', ')
    self.tags.clear
    split.each do |t|
      tag = Tag.where(:name => t).first_or_create
      self.tags << tag
    end
  end

  def categories_full_list
    self.categories.all.map { |c| c.name }.join(', ')
  end

  def categories_full_list=(categories)
    split = categories.split(', ')
    self.categories.clear
    split.each do |c|
      category = Category.where(:name => c).first_or_create
      self.categories << category
    end
  end

  validates :title, presence: true
  validates :default_servings, presence: true, length: {maximum: 2}

  has_and_belongs_to_many :categories, optional: true
  has_and_belongs_to_many :tags, optional: true

  has_many :ingredient_lists, inverse_of: :recipe, dependent: :destroy
  has_many :ingredients, through: :ingredient_lists
  
  accepts_nested_attributes_for :ingredients, reject_if:proc { |att| att['name'].blank? }
end
