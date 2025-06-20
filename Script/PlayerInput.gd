# PlayerInput.gd
extends Node

# Сигнал, който ще излъчваме, когато играчът избере нова посока.
signal direction_changed(new_direction: Vector2)

func _ready():
	set_process(true)

func _process(_delta):
	# Използваме if/elif, за да сме сигурни, че се обработва само едно натискане на кадър.
	if Input.is_action_just_pressed("ui_right"):
		emit_signal("direction_changed", Vector2.RIGHT)
	elif Input.is_action_just_pressed("ui_left"):
		emit_signal("direction_changed", Vector2.LEFT)
	elif Input.is_action_just_pressed("ui_down"):
		emit_signal("direction_changed", Vector2.DOWN)
	elif Input.is_action_just_pressed("ui_up"):
		emit_signal("direction_changed", Vector2.UP)
		
		# --- _process функция (без промяна) Старо ---
#func _process(delta):
	#if Input.is_action_just_pressed("ui_right"):
		#if move_direction != Vector2.LEFT:
			#next_direction = Vector2.RIGHT
	#elif Input.is_action_just_pressed("ui_left"):
		#if move_direction != Vector2.RIGHT:
			#next_direction = Vector2.LEFT
	#elif Input.is_action_just_pressed("ui_down"):
		#if move_direction != Vector2.DOWN:
			#next_direction = Vector2.DOWN
	#elif Input.is_action_just_pressed("ui_up"):
		#if move_direction != Vector2.UP:
			#next_direction = Vector2.UP
