class IngredientList < ApplicationRecord

  def fill_data(prm, ingredient_id)
    self.ingredient_id = ingredient_id
    self.amount = prm[:amount] unless prm[:amount].blank?
    self.alt_amount = prm[:alt_amount] unless prm[:alt_amount].blank?
    self.unit_id = prm[:unit_id] unless prm[:unit_id].blank?
    self.alt_unit_id = prm[:alt_unit_id] unless prm[:alt_unit_id].blank?
    self.prep = prm[:prep] unless prm[:prep].blank?
    self.strip_whitespace
    self.save
  end

  def strip_whitespace
    self.prep.gsub!(/(\A\s*|\s*\z)/, '') unless self.prep.blank?
    self.amount.gsub!(/(\A\s*|\s*\z)/, '') unless self.amount.blank?
    self.alt_amount.gsub!(/(\A\s*|\s*\z)/, '') unless self.alt_amount.blank?
  end

  validates :amount, :alt_amount, length: {maximum: 5}
  belongs_to :recipe, optional: true
  validates :recipe, presence: true

  belongs_to :ingredient, optional: true
  accepts_nested_attributes_for :ingredient, allow_destroy: true, reject_if:proc { |att| att['name'].blank? }

  belongs_to :unit, optional: true
  belongs_to :alt_unit, class_name: "Unit", optional: true
end
