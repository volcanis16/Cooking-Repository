module ApplicationHelper
  def link_to_add_row(name, f, association, **args)
    ingredient = Ingredient.new(id: (Time.now.to_f * 1000).to_i)
    new_object = f.object.send(association).build
    new_object.ingredient = ingredient
    id = new_object.object_id
    fields = f.simple_fields_for(association, new_object, child_index: id) do |builder|
      render("ingredient", f: builder)
    end

    link_to(name, '#', class: "add_fields " + args[:class], data: {id: id, fields: fields.gsub("\n", "")})
  end

  def recipe_count(input, table)
    Recipe.joins(table.to_sym).where("#{table}.name" => input[:name]).count
  end

  def no_space(input)
    input.gsub!(/\s/, '')
  end

  def user_admin?
    current_user.admin
  end
end
