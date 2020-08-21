class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.strip_whitespace(value)
    value.gsub!(/(\A\s*|\s*\z)/, '')
  end
end
