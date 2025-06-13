# GameState.gd
extends Node

# Променливи, които ще получим от Main/GameScreen.
var player: Node
var score_label: Label # Очакваме Label, а не CanvasLayer
var time_label: Label  # Очакваме Label
var food_manager: Node

const START_TIME = 40.0

var score = 0
var round_time_left = 0.0
var is_playing = false

signal round_ended

# --- НОВИ ФУНКЦИИ ЗА UI ---
func update_score_ui():
	if score_label:
		score_label.text = "Score: " + str(score)

func update_time_ui():
	if time_label:
		time_label.text = "Time: " + str(ceil(round_time_left))
# --- КРАЙ НА НОВИТЕ ФУНКЦИИ ---

func _process(delta: float):
	if is_playing:
		round_time_left -= delta
		update_time_ui() # Използваме новата функция

		if round_time_left <= 0:
			is_playing = false
			emit_signal("round_ended")

func start_new_round():
	score = 0
	is_playing = true
	round_time_left = START_TIME
	
	update_score_ui() # Използваме новата функция
	update_time_ui()  # Използваме новата функция

	player.reset_snake()
	player.create_initial_body(2)
	
	food_manager.clear_food()
	food_manager.spawn_food()
	
	# След като абсолютно всичко е готово, казваме на играча да стартира цикъла на движение.
	player.start_game_loop()

func _on_player_food_eaten():
	score += 10
	update_score_ui() # Използваме новата функция
	food_manager.spawn_food()
