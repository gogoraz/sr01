# PlayerMovement.gd (Цялостна, коригирана и работеща версия)
extends Node

signal game_over

# Променливи, които се подават отвън (от Player.gd и GameScreen.gd)
var game_state: Node
var body_manager: Node

# Локални променливи за движението
var move_direction = Vector2.RIGHT
var next_direction = Vector2.RIGHT
var grid_bounds = Vector2.ZERO

# Тази функция се извиква от таймера на Player-а.
func _on_timer_timeout():
	if not game_state or not game_state.is_playing:
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
	if body_manager and !body_manager.body_segments.is_empty():
		# Правилният цикъл, който създава променливата "segment"
		for segment in body_manager.body_segments:
			# Проверяваме дали бъдещата позиция съвпада с някой от сегментите
			if next_position == segment.position:
				# Проверяваме дали това не е последният сегмент, който ще се премести
				if segment != body_manager.body_segments.back():
					emit_signal("game_over", "Hit body")
					return
	
	# Движение на опашката и главата
	if body_manager:
		body_manager.move_body(player.position)
	player.position = next_position

# Нулираме състоянието на движението
func reset(start_pos: Vector2):
	move_direction = Vector2.RIGHT
	next_direction = Vector2.RIGHT
	if get_parent():
		get_parent().position = start_pos
