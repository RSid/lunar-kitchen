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

  def self.db_connection
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
      all_recipes << Recipe.new(recipe["id"],recipe["name"],recipe["instructions"],recipe["description"],)
    end
    all_recipes
  end


 # For instance, when you query the database
 # for all of the recipes, you don't
 #  want to return an array of hashes,
 #  you wan't to return an array of Recipe objects.


  def find(id)
    sql = 'SELECT * FROM recipes WHERE id = $1 LIMIT 1'

    recipe = db_connection do |db|
      db.exec_params(sql, [id])
    end
    recipe.to_a
  end

end


