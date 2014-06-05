require 'pry'
require 'pg'

class Ingredient
  def initialize (id,name,recipe_id)
    @id = id
    @name = name
    @recipe_id = id
  end

  def name
    @name
  end

end
