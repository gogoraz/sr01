# GameState.gd
extends Node

# Променливи, които ще получим от Main.
var player: Node
var game_ui: CanvasLayer
var food_manager: Node

# --- НОВИ ПРОМЕНЛИВИ ---
var START_TIME = 20.0 # Начално време, което НЕ се променя. Използвай const, за да го подчертаеш.

# Променливи за състоянието, които преди бяха в Main.
var score = 0
var round_time_left = 0.0 # Тази ще я задаваме при старт на рунда.
var is_playing = false

# Сигнал, който ще каже на Main, че рундът е приключил.
signal round_ended

func _process(delta: float):
	if is_playing:
		round_time_left -= delta
		game_ui.update_time(round_time_left)

		if round_time_left <= 0:
			is_playing = false
			emit_signal("round_ended")

func start_new_round():
	score = 0
	is_playing = true
	
	# Всеки път, когато започва нов рунд, задаваме оставащото време
	# да бъде равно на нашата начална константа.
	round_time_left = START_TIME
	
	game_ui.update_score(score)
	game_ui.update_time(round_time_left)

	player.reset_snake()
	player.create_initial_body(2)
	
	# ПЪРВО изчистваме всякаква останала храна.
	food_manager.clear_food()
	# СЛЕД ТОВА създаваме новата храна за рунда.
	food_manager.spawn_food()

func _on_player_food_eaten():
	score += 10
	game_ui.update_score(score)
	food_manager.spawn_food()
