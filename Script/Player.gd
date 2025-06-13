# Player.gd (Цялостна, коригирана и работеща версия)
extends Area2D

signal food_eaten

# Референции към нашите компоненти
@onready var input_manager = $PlayerInput
@onready var movement_manager = $PlayerMovement
@onready var body_manager = $PlayerBody
@onready var move_timer = $Timer

# Тази променлива остава тук, за да можем лесно да я настройваме от инспектора.
@export_range (0.05, 0.4) var move_speed = 0.15

# Тези променливи се задават отвън (от GameScreen.gd)
var grid_bounds = Vector2.ZERO
var start_position = Vector2.ZERO

func _ready():
	# Настройваме скоростта на таймера.
	move_timer.wait_time = move_speed

	# --- КОРИГИРАНА ЧАСТ 1: СВЪРЗВАНЕ НА СИГНАЛИТЕ ---
	# Свързваме сигналите от компонентите към функции в този скрипт.
	input_manager.direction_changed.connect(_on_direction_changed)
	movement_manager.game_over.connect(_on_game_over)
	
	# ТОВА Е КЛЮЧОВИЯТ ЛИПСВАЩ РЕД:
	# Изрично свързваме "timeout" сигнала на нашия таймер с функцията "_on_timer_timeout"
	# в нашия компонент "movement_manager".
	move_timer.timeout.connect(movement_manager._on_timer_timeout)
	
	# Подаваме на PlayerMovement референция към PlayerBody, за да не се търсят сами.
	movement_manager.body_manager = body_manager


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

# --- КОРИГИРАНА ЧАСТ 2: СТАРТИРАНЕ НА ТАЙМЕРА ---
# Тази функция се извиква отвън (от GameState), след като всичко е готово.
func start_game_loop():
	# ТОВА Е ВТОРИЯТ КЛЮЧОВ ЛИПСВАЩ РЕД:
	move_timer.start()


func _on_direction_changed(new_direction: Vector2):
	# Просто препращаме информацията към Movement компонента.
	# Проверката .abs() предотвратява обръщане на 180 градуса.
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
