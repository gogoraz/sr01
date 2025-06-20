# Player.gd (Нова, по-чиста версия)
extends Area2D

signal food_eaten

# Компоненти, които ще бъдат зададени отвън
var input_manager: Node
var movement_manager: Node
var body_manager: Node
var move_timer: Timer

@export_range(0.05, 0.4) var move_speed = 0.15

var _grid_bounds = Vector2.ZERO
var start_position = Vector2.ZERO

var grid_bounds:
	set(value):
		_grid_bounds = value
		# Update movement_manager if it exists
		if has_node("PlayerMovement"):
			$PlayerMovement.grid_bounds = value
	get:
		return _grid_bounds

func _ready():
	# Намираме компонентите чрез get_node, защото сме сигурни, че са деца на този възел.
	input_manager = $PlayerInput
	movement_manager = $PlayerMovement
	body_manager = $PlayerBody
	move_timer = $Timer

	move_timer.wait_time = move_speed

	# Свързваме сигналите
	input_manager.direction_changed.connect(_on_direction_changed)
	movement_manager.game_over.connect(_on_game_over)
	move_timer.timeout.connect(movement_manager._on_timer_timeout)
	
	# Предаваме grid_bounds на movement_manager
	if movement_manager:
		movement_manager.grid_bounds = grid_bounds

	set_process_input(true)
	# grab_focus()

func create_initial_body(length: int):
	body_manager.create_initial_body(length, position, movement_manager.move_direction)

func reset_snake():
	body_manager.reset()
	movement_manager.reset(start_position)

func get_occupied_cells():
	var cells = body_manager.get_cells()
	cells.append(position / Global.TILE_SIZE)
	return cells

func start_game_loop():
	print("Player: Starting move timer")
	move_timer.start()
	
	

func _on_direction_changed(new_direction: Vector2):
	if movement_manager.move_direction.abs() != new_direction.abs():
		movement_manager.next_direction = new_direction

func _on_area_entered(area):
	if area.is_in_group("food"):
		area.queue_free()
		body_manager.segments_to_add += 1
		emit_signal("food_eaten")

func _on_game_over(reason: String):
	print("GAME OVER! Reason: ", reason)
	get_tree().reload_current_scene()
