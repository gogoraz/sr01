# FoodManager.gd (Нова, по-чиста версия)
extends Node

# Променливи, които ще получим от Main.
var player: Node
var grid_width: int
var grid_height: int

var food_scene = preload("res://Scene/food.tscn")

# Видове храна и техните вероятности
enum FoodType { STANDARD, TIME_BONUS, SPECIAL_BUFF, TRAP }
var food_probabilities = {
	FoodType.STANDARD: 0.7,
	FoodType.TIME_BONUS: 0.2,
	FoodType.SPECIAL_BUFF: 0.05,
	FoodType.TRAP: 0.05
}
# Ефекти на различните видове храна
var food_effects = {
	FoodType.STANDARD: {"score": 10, "grow": 1},
	FoodType.TIME_BONUS: {"time": 5.0, "score": 5},
	FoodType.SPECIAL_BUFF: {"score": 20, "buff": "shield"}, # Щит за един удар
	FoodType.TRAP: {"score": -5, "effect": "slow"} # Забавя змията временно
}
# Цветове за визуално разграничаване на видовете храна
var food_colors = {
	FoodType.STANDARD: Color(0, 1, 0), # Зелен
	FoodType.TIME_BONUS: Color(1, 1, 0), # Жълт
	FoodType.SPECIAL_BUFF: Color(0, 1, 1), # Циан
	FoodType.TRAP: Color(1, 0, 0) # Червен
}

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
	
	# Избиране на вид храна въз основа на вероятностите
	var food_type = FoodType.STANDARD
	var rand = randf()
	var cumulative_prob = 0.0
	for type in food_probabilities:
		cumulative_prob += food_probabilities[type]
		if rand <= cumulative_prob:
			food_type = type
			break
	
	# Настройка на свойствата на храната според вида
	new_food.food_type = food_type
	new_food.effect = food_effects[food_type]
	new_food.modulate = food_colors[food_type]
	
	# Намиране на свободна позиция за храната
	while true:
		var rand_x = randi() % grid_width
		var rand_y = randi() % grid_height
		var random_grid_pos = Vector2(rand_x, rand_y)

		if not snake_cells.has(random_grid_pos):
			spawn_position = random_grid_pos * Global.TILE_SIZE
			break

	new_food.position = spawn_position
	get_parent().add_child(new_food)
