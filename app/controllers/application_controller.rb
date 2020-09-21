class ApplicationController < ActionController::Base
  ##Break into array, remove whitespace, remove empty entries.
  def split_and_strip(input, split_point)
    input = input.split(split_point).map {|i| i.strip }
    input.map { |i| i.blank? ? next : i }.compact
  end

end
