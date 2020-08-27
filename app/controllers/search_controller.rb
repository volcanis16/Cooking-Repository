class SearchController < ApplicationController

  def search
    input_split = result_split(params[:search].downcase)
    @recipes = Recipe.all
    puts @recipes
    single_column_only_query(input_split[0], "categories") unless input_split[0].empty?
    single_column_only_query(input_split[1], "tags") unless input_split[1].empty?
    full_query(input_split[2]) unless input_split[2].empty?
    puts @recipes
    @recipe_count = @recipes.count
  end


private

  def result_split(search)
    search_split = search.split(',').map {|s| s.strip }
    search_split = search_split.map { |s| s.blank? ? next : s }.compact

    search_split = search_split.partition { |s| s.include?("tag:") }
    search_tags = search_split[0].map { |t| t.gsub!(/tag:/, '')}
    search_split = search_split[1]

    search_split = search_split.partition { |s| s.include?("cat:") }
    search_cats = search_split[0].map { |t| t.gsub!(/cat:/, '')}
    search_else = search_split[1]

    return [search_cats, search_tags, search_else]
  end

  def single_column_only_query(input, table)
    input = input.partition { |s| s.include?('-') }
    positive_input = input[1]
    negative_input = input[0].map {|s| s.gsub!(/-/, "")}

    unless positive_input.empty?
      mapped_pos_input = positive_input.map { |name| ["#{name}"] }
      positive_where_arg = [(["#{table}.name LIKE ?"] * positive_input.length).join(' AND ')] + mapped_pos_input
    end

    unless negative_input.empty?
      mapped_neg_input = negative_input.map { |name| ["#{name}"] }
      negative_where_arg = [(["#{table}.name LIKE ?"] * negative_input.length).join(' OR ')] + mapped_neg_input
    end

    case 
    when positive_input.length > 0 && negative_input.length > 0
      @recipes = @recipes.joins(table.to_sym).where(positive_where_arg).where.not(negative_where_arg)
    when positive_input.length > 0
      @recipes = @recipes.joins(table.to_sym).where(positive_where_arg)
    when negative_input.length > 0
      @recipes = @recipes.joins(table.to_sym).where.not(negative_where_arg)
    else
      return
    end
  end

  def full_query(input)
    input = input.partition { |s| s.include?('-') }
    positive_input = input[1]
    negative_input = input[0].map {|s| s.gsub!(/-/, "")}

    unless positive_input.empty?
      mapped_pos_input = positive_input.map { |name| ["#{name}", "#{name}", "%#{name}%"] }.join(',').split(',')
      positive_where_arg = [(['(tags.name LIKE ? OR categories.name Like ? OR recipes.title LIKE ?)'] * positive_input.length).join(' AND ')] + mapped_pos_input
    end

    unless negative_input.empty?
      mapped_neg_input = negative_input.map { |name| ["#{name}", "#{name}", "%#{name}%"] }.join(',').split(',')
      negative_where_arg = [(['(tags.name LIKE ? AND categories.name Like ? AND recipes.title LIKE ?)'] * negative_input.length).join(' OR ')] + mapped_neg_input
    end

    case 
    when positive_input.length > 0 && negative_input.length > 0
      @recipes = @recipes.joins(:categories, :tags).where(positive_where_arg).where.not(negative_where_arg).distinct
    when positive_input.length > 0
      @recipes = @recipes.joins(:categories, :tags).where(positive_where_arg).distinct
    when negative_input.length > 0
      @recipes = @recipes.joins(:categories, :tags).where.not(negative_where_arg).distinct
    else
      return
    end
  end

end