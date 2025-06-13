# Player.gd (Новата, изчистена версия)
extends Area2D

signal food_eaten

# Референции към нашите компоненти
@onready var input_manager = $PlayerInput
@onready var movement_manager = $PlayerMovement
@onready var body_manager = $PlayerBody
@onready var move_timer = $Timer

# Тази променлива остава тук, за да можем лесно да я настройваме от инспектора.
@export_range (0.05, 0.4) var move_speed = 0.15

# Тези променливи се задават отвън (от main.gd)
var grid_bounds = Vector2.ZERO
var start_position = Vector2.ZERO

func _ready():	
	move_timer.wait_time = move_speed
	
	# Свързваме сигналите от компонентите към функции в този скрипт.
	input_manager.direction_changed.connect(_on_direction_changed)
	movement_manager.game_over.connect(_on_game_over)
	move_timer.timeout.connect(movement_manager._on_timer_timeout) # Свързваме таймера директно към Movement компонента!
# --- ДОБАВИ ТОЗИ РЕД ТУК ---
	# Изчакваме един кадър, за да сме сигурни, че main.gd е задал grid_bounds,
	# след което го предаваме на компонента за движение.
	#await get_tree().process_frame
	
	# Изрично свързваме "timeout" сигнала на нашия таймер с функцията "_on_timer_timeout"
	# в нашия компонент "movement_manager".
	move_timer.timeout.connect(movement_manager._on_timer_timeout)
	
	# След като сме сигурни, че всичко е готово, стартираме таймера ръчно.
	
	movement_manager.grid_bounds = self.grid_bounds

func start_game_loop():
	move_timer.start()
	
func create_initial_body(length: int):
	body_manager.create_initial_body(length, position, movement_manager.move_direction)

func reset_snake():
	# Командваме на всеки компонент да се нулира.
	body_manager.reset()
	movement_manager.reset(start_position) # Подаваме стартовата позиция.

func get_occupied_cells():
	var cells = body_manager.get_cells()
	cells.append(position / Global.TILE_SIZE) # Добавяме и главата.
	return cells

func _on_direction_changed(new_direction: Vector2):
	# Просто препращаме информацията към Movement компонента.
	if movement_manager.move_direction.abs() != new_direction.abs():
		movement_manager.next_direction = new_direction

func _on_area_entered(area):
	if area.is_in_group("food"):
		area.queue_free()
		body_manager.segments_to_add += 1 # Казваме на Body компонента, че трябва да расте.
		emit_signal("food_eaten")

func _on_game_over(reason: String):
	print("GAME OVER! Reason: ", reason)
	get_tree().reload_current_scene()
