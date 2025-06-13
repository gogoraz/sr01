# PlayerMovement.gd
extends Node

signal game_over

var game_state: Node # Нова променлива, която ще получим отвън.

var move_direction = Vector2.RIGHT
var next_direction = Vector2.RIGHT
var grid_bounds = Vector2.ZERO

# Ще получим референция към PlayerBody.
@onready var body_manager = get_parent().get_node("PlayerBody")

func _on_timer_timeout():
	if not game_state.is_playing:
		return
	
	var player = get_parent() # Вземаме главния Player възел.
	
	move_direction = next_direction
	var next_position = player.position + move_direction * Global.TILE_SIZE

	# Проверка за сблъсък със стена:
	if grid_bounds != Vector2.ZERO:
		if (next_position.x < 0 or
			next_position.x >= grid_bounds.x * Global.TILE_SIZE or
			next_position.y < 0 or
			next_position.y >= grid_bounds.y * Global.TILE_SIZE):
			
			emit_signal("game_over", "Hit a wall")
			return

	# Проверка за сблъсък с тялото:
	for segment in body_manager.body_segments:
		if segment != body_manager.body_segments.back(): 
			if next_position == segment.position:
				emit_signal("game_over", "Hit body")
				return 
	
	# Движение на опашката и главата
	body_manager.move_body(player.position)
	player.position = next_position

func reset(start_pos: Vector2):
	move_direction = Vector2.RIGHT
	next_direction = Vector2.RIGHT
	get_parent().position = start_pos
