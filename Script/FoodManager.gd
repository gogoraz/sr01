# FoodManager.gd (Нова, по-чиста версия)
extends Node

# Променливи, които ще получим от Main.
var player: Node
var grid_width: int
var grid_height: int

var food_scene = preload("res://Scene/food.tscn")

# Нова променлива за offset на решетката.
var grid_offset = Vector2(0, 0)

# Нова функция, която само изчиства храната.
func clear_food():
	# Намираме ВСИЧКИ възли в група "food" и ги изтриваме.
	# Това е по-надеждно от find_child.
	for food_item in get_tree().get_nodes_in_group("food"):
		food_item.queue_free()

# Старата функция, но без логиката за чистене.
func spawn_food():
	var snake_cells = player.get_occupied_cells()
	print("Snake cells: ", snake_cells) # Print the occupied snake cells for debugging
	var new_food = food_scene.instantiate()
	var spawn_position = Vector2.ZERO
	var max_attempts = 100  # Prevent infinite loops
	var attempts = 0

	while attempts < max_attempts:
		var rand_x = randi() % grid_width
		var rand_y = randi() % grid_height
		var random_grid_pos = Vector2(rand_x, rand_y)

		# Ensure the position is within grid bounds
		random_grid_pos.x = clamp(random_grid_pos.x, 0, grid_width - 1)
		random_grid_pos.y = clamp(random_grid_pos.y, 0, grid_height - 1)

		if not snake_cells.has(random_grid_pos):
			spawn_position = grid_offset + random_grid_pos * Global.TILE_SIZE
			break
		attempts += 1

	# If we couldn't find a valid position after max attempts, try to find any empty cell
	if attempts >= max_attempts:
		# Fallback: try every cell until we find an empty one
		for x in range(grid_width):
			for y in range(grid_height):
				var pos = Vector2(x, y)
				if not snake_cells.has(pos):
					spawn_position = grid_offset + pos * Global.TILE_SIZE
					break

	# Make sure the position is within bounds one final time
	spawn_position.x = clamp(spawn_position.x, grid_offset.x, grid_offset.x + (grid_width - 1) * Global.TILE_SIZE)
	spawn_position.y = clamp(spawn_position.y, grid_offset.y, grid_offset.y + (grid_height - 1) * Global.TILE_SIZE)

	new_food.position = spawn_position
	get_parent().add_child(new_food)
