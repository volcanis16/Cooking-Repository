module ApplicationHelper
  def link_to_add_row(name, f, association, **args)
    new_object = f.object.send(association).build
    id = new_object.object_id
    fields = f.simple_fields_for(association, new_object, child_index: id) do |builder|
      builder.object.ingredient_lists.build
      render(association.to_s.singularize, f: builder)
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
