require 'pry'
require 'pg'

class Recipe

  def initialize (id,name,instructions,description)
    @id = id
    @description = description
    @name = name
    @instructions = instructions
    @description = description
  end

  def id
    @id
  end

  def name
    @name
  end

  def description
    if description != nil
      @description
    else
      "This recipe doesn't have a description."
  end

  def instructions
    @instructions
  end

  def self.db_connection
    begin
      connection = PG.connect(dbname: 'sys_recipes')
      yield(connection)
    ensure
      connection.close
    end
  end

def db_connection
    begin
      connection = PG.connect(dbname: 'sys_recipes')
      yield(connection)
    ensure
      connection.close
    end
  end

  def self.all
    sql = 'SELECT * FROM recipes'

    recipes = db_connection do |db|
      db.exec(sql)
    end

    all_recipes = []
    (recipes.to_a).each do |recipe|
      all_recipes << Recipe.new(recipe["id"],recipe["name"],recipe["instructions"],recipe["description"])
    end
    all_recipes
  end


  def self.find(id)
    sql = 'SELECT * FROM recipes WHERE id = $1'

    recipe = db_connection do |db|
      db.exec_params(sql, [id])
    end
    recipe=recipe.first
    Recipe.new(recipe["id"],recipe["name"],recipe["instructions"],recipe["description"])
  end

  def ingredients
    sql = 'SELECT ingredients.name FROM ingredients JOIN recipes ON ingredients.recipe_id=recipes.id WHERE recipes.id=$1'

    ingredients = db_connection do |db|
      db.exec_params(sql,[@id])
    end

    all_ingredients = []
    (ingredients.to_a).each do |ingredient|
      all_ingredients << Ingredient.new(ingredient["id"],ingredient["name"],ingredient["recipe_id"])
    end
    all_ingredients


  end


end


