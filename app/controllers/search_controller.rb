class SearchController < ApplicationController

  def search
    input_split = result_split(params[:search].downcase)
    @recipes = Recipe.all
    @recipe_count = 0
    @recipes = cat_query(input_split[0], @recipes) unless input_split[0].empty?
    return if @recipes.blank?
    @recipes = tag_query(input_split[1], @recipes) unless input_split[1].empty?
    return if @recipes.blank?
    @recipes = full_query(input_split[2], @recipes) unless input_split[2].empty?

    @recipes = Kaminari.paginate_array(@recipes).page(params[:page]).per(30)
    @recipe_count = @recipes.count
  end


private

  def result_split(search)
    ##Break into array, remove whitespace, remove empty entries.
    search_split = split_and_strip(search, ",")

    ##Split off tag specific
    search_split = search_split.partition { |s| s.include?("tag:") }
    search_tags = search_split[0].map { |s| s.gsub!(/tag:/, '')}

    ##Split off category specific
    search_split = search_split[1].partition { |s| s.include?("cat:") }
    search_cats = search_split[0].map { |s| s.gsub!(/cat:/, '')}

    ##Remainder
    search_else = search_split[1]

    ##Split positive and negative, remove "-"
    search_tags = split_neg(search_tags)
    search_cats = split_neg(search_cats)
    search_else = split_neg(search_else)

    ##Add general negative entries to tags and cats
    search_tags[0] += search_else[0]
    search_cats[0] += search_else[0]

    return [search_cats, search_tags, search_else]
  end

  def cat_query(input, recipes)
    recipes = cat_positive(input[1], recipes) if input[1].length > 0
    return recipes if recipes.blank?
    recipes = cat_negative(input[0], recipes) if input[0].length > 0
    recipes.uniq
  end

  def tag_query(input, recipes)
    recipes = tag_positive(input[1], recipes) if input[1].length > 0
    return recipes if recipes.blank?
    recipes = tag_negative(input[0], recipes) if input[0].length > 0
    recipes.uniq
  end

  def full_query(input, recipes)
    ##Positive query
    unless input[1].empty?
      input[1].each_with_index do |name, idx|
        recipes = Recipe.joins("INNER JOIN categories_recipes crf#{idx} ON crf#{idx}.recipe_id = recipes.id 
          INNER JOIN categories cf#{idx} ON cf#{idx}.id = crf#{idx}.category_id 
          INNER JOIN recipes_tags rtf#{idx} ON rtf#{idx}.recipe_id = recipes.id 
            INNER JOIN tags tf#{idx} ON tf#{idx}.id = rtf#{idx}.tag_id"
              ).where(["cf#{idx}.name = ? OR tf#{idx}.name = ? OR recipes.title LIKE ?", name, name, "%#{name}%"]).merge(recipes)
      end
    end

    ##Negative query
    unless input[0].empty?
      mapped_neg_input = input[0].map { |name| "%#{name}%" }
      negative_where_arg = [(['(recipes.title LIKE ?)'] * input[0].length).join(' OR ')] + mapped_neg_input
      recipes = Recipe.where.not(negative_where_arg).merge(recipes)
    end
    recipes.uniq
  end

  def cat_positive(input, recipes)
    input.each_with_index do |name, idx|
      recipes = Recipe.joins("INNER JOIN categories_recipes cr#{idx} ON cr#{idx}.recipe_id = recipes.id INNER JOIN
         categories c#{idx} ON c#{idx}.id = cr#{idx}.category_id").where("c#{idx}.name = ?", name).merge(recipes)
    end
    recipes
  end

  def cat_negative(input, recipes)
    input.each_with_index do |name, idx|
      category = Category.find_by("name = ?", name)
      if !category.nil?
        recipes = Recipe.joins("INNER JOIN categories_recipes ncr#{idx} ON ncr#{idx}.recipe_id = recipes.id INNER JOIN
           categories nc#{idx} ON nc#{idx}.id = ncr#{idx}.category_id").where('recipes.id NOT IN (?)', category.recipes.pluck(:id)).merge(recipes)
      end
    end
    recipes
  end

  def tag_positive(input, recipes)
    input.each_with_index do |name, idx|
      recipes = Recipe.joins("INNER JOIN recipes_tags rt#{idx} ON rt#{idx}.recipe_id = recipes.id INNER JOIN
         tags t#{idx} ON t#{idx}.id = rt#{idx}.tag_id").where("t#{idx}.name = ?", name).merge(recipes)
    end
    recipes
  end

  def tag_negative(input, recipes)
    input.each_with_index do |name, idx|
      tag = Tag.find_by("name = ?", name)
      if !tag.nil?
        recipes = Recipe.joins("INNER JOIN recipes_tags nrt#{idx} ON nrt#{idx}.recipe_id = recipes.id INNER JOIN
          tags nt#{idx} ON nt#{idx}.id = nrt#{idx}.tag_id").where('recipes.id NOT IN (?)', tag.recipes.pluck(:id)).merge(recipes)
      end
    end
    recipes
  end

  def split_neg(input)
    input = input.partition { |s| s.include?('-') }
    input[0] = input[0].map { |s| s.gsub!(/-/, '')}
    input
  end

end