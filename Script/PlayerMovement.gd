# PlayerMovement.gd (Финална, работеща версия)
extends Node

signal game_over

var game_state: Node
var body_manager: Node

var move_direction = Vector2.RIGHT
var next_direction = Vector2.RIGHT
var grid_bounds = Vector2.ZERO

func _on_timer_timeout():
	if not game_state:
		print("PlayerMovement: game_state is NULL!")
		return
			
	if not game_state.is_playing:
		return

	var player = get_parent()
	move_direction = next_direction
	var next_position = player.position + move_direction * Global.TILE_SIZE
	
	# Debug information
	print("Current position: ", player.position)
	print("Next position: ", next_position)
	print("Grid bounds: ", grid_bounds, " (in tiles)")
	if grid_bounds != Vector2.ZERO:
		print("Grid size in pixels: ", grid_bounds * Global.TILE_SIZE)
	else:
		print("Grid size: Not set")

	# Проверка за сблъсък със стена
	if grid_bounds != Vector2.ZERO:
		var grid_pixel_size = grid_bounds * Global.TILE_SIZE
		
		# Check for wall collision
		if (next_position.x < 0 or 
			next_position.x >= grid_pixel_size.x or
			next_position.y < 0 or
			next_position.y >= grid_pixel_size.y):
			emit_signal("game_over", "Hit wall")
			return

	# Проверка за сблъсък с тялото
	if body_manager and !body_manager.body_segments.is_empty():
		if body_manager.body_segments.size() > 1:
			for segment in body_manager.body_segments:
				if segment and next_position == segment.position:
					if segment != body_manager.body_segments.back():
						emit_signal("game_over", "Hit body")
						return

	# Движение
	if body_manager:
		body_manager.move_body(player.position)
	player.position = next_position

func reset(start_pos: Vector2):
	move_direction = Vector2.RIGHT
	next_direction = Vector2.RIGHT
	if get_parent():
		get_parent().position = start_pos
