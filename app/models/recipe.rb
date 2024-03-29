class Recipe < ApplicationRecord
  #Build new Recipe
  def self.build_from_form(prm)
    recipe = Recipe.new(title: prm[:title], description: prm[:description], notes: prm[:notes], 
                          default_servings: prm[:default_servings], main_image: prm[:main_image], cook: prm[:cook], prep: prm[:prep], rating: prm[:rating])

    #Remove whitespace from beginning and end
    recipe.title = strip_whitespace(recipe.title)

    #Initialize ingredients and add ingredient_list relations and info
    recipe = initialize_ingredients(recipe, prm)
  end

  #Edit existing recipe
  def self.update_data(recipe, prm)
    recipe.assign_attributes(title: prm[:title], description: prm[:description], notes: prm[:notes], 
                          default_servings: prm[:default_servings], cook: prm[:cook], prep: prm[:prep], rating: prm[:rating])
    recipe.main_image.attach(prm[:main_image]) unless prm[:main_image].blank?
    recipe.title = strip_whitespace(recipe.title)

    #Clear existing ingredient links then create new links and information
    recipe.ingredients.clear
    recipe = initialize_ingredients(recipe, prm)
  end

  #Find or initialize each ingredient and add data to ingredient_list table
  def self.initialize_ingredients(recipe, prm)
    prm[:ingredient_lists_attributes].each do |key, value|
      unless value[:_destroy] == '1' || value[:ingredient_attributes][:name].blank?
        #Delay for 1 millisecond to make sure ID's are unique
        sleep(0.001)
        ingredient = Ingredient.where(name: value[:ingredient_attributes][:name].downcase).first_or_initialize(id: (Time.now.to_f * 1000).to_i)
        ingredient.name = strip_whitespace(ingredient.name)
        recipe.ingredients << ingredient
        ingredient_list = recipe.ingredient_lists.last
        ingredient_list.fill_data(value, ingredient.id)
      end
    end

    recipe
  end

  def self.update_notes(recipe, prm)
    recipe.notes += "\n\n#{prm[:notes]}"
    recipe
  end

  #Combines all tags into one string
  def tags_full_list
    self.tags.all.map { |t| t.name }.join(', ')
  end

  #Breaks down tags input and creates any new ones
  def tags_full_list=(tags)
    split = tags.downcase.split(', ')

    #Clear tags attached to recipe
    self.tags.clear

    #Find the tag or create a new one, then assign it to calling recipe
    split.each do |t|
      tag = Tag.where(:name => t).first_or_create
      self.tags << tag
    end
  end

  #Combines all categories into one string
  def categories_full_list
    self.categories.all.map { |c| c.name }.join(', ')
  end

  #Breaks down categories input and creates any new ones
  def categories_full_list=(categories)
    split = categories.downcase.split(', ')

    #Clear categories attached to recipe
    self.categories.clear

    #Find the category or create a new one, then assign it to calling recipe
    split.each do |c|
      category = Category.where(:name => c).first_or_create
      self.categories << category
    end
  end

  validates :title, presence: true
  validates :default_servings, length: {maximum: 2}
  validate :acceptable_image

  has_and_belongs_to_many :categories, optional: true
  has_and_belongs_to_many :tags, optional: true

  has_many :ingredient_lists, inverse_of: :recipe, dependent: :destroy
  has_many :ingredients, through: :ingredient_lists

  has_one_attached :main_image
  
  accepts_nested_attributes_for :ingredient_lists, allow_destroy: true

  def acceptable_image
    return unless main_image.attached?

    unless main_image.byte_size <= 3.megabyte
      errors.add(:main_image, "is too big")
    end

    acceptable_types = ["image/jpeg", "image/png"]
    unless acceptable_types.include?(main_image.content_type)
      errors.add(:main_image, "must be a JPEG or PNG")
    end
  end
end
