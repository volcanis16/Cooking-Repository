module ApplicationHelper
  def link_to_add_row(name, f, association, **args)
    new_object = f.object.send(association).build
    fields = f.simple_fields_for(association, new_object) do |builder|
      builder.object.ingredient_lists.build
      render(association.to_s.singularize, f: builder)
    end

    link_to(name, '#', class: "add_fields " + args[:class], data: {fields: fields.gsub("\n", "")})
  end

end
