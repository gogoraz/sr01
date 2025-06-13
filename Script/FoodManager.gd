# FoodManager.gd (Нова, по-чиста версия)
extends Node

# Променливи, които ще получим от Main.
var player: Node
var grid_width: int
var grid_height: int

var food_scene = preload("res://Scene/food.tscn")

# Нова функция, която само изчиства храната.
func clear_food():
	# Намираме ВСИЧКИ възли в група "food" и ги изтриваме.
	# Това е по-надеждно от find_child.
	for food_item in get_tree().get_nodes_in_group("food"):
		food_item.queue_free()

# Старата функция, но без логиката за чистене.
func spawn_food():
	var snake_cells = player.get_occupied_cells()
	var new_food = food_scene.instantiate()
	var spawn_position = Vector2.ZERO

	while true:
		var rand_x = randi() % grid_width
		var rand_y = randi() % grid_height
		var random_grid_pos = Vector2(rand_x, rand_y)

		if not snake_cells.has(random_grid_pos):
			spawn_position = random_grid_pos * Global.TILE_SIZE
			break

	new_food.position = spawn_position
	get_parent().add_child(new_food)
