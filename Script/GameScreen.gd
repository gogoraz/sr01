# GameScreen.gd (Финална, работеща версия)
extends MarginContainer

@onready var player = $VerticalSplit/MainContent/GameViewportContainer/SubViewport/Main/Player
@onready var score_label = $VerticalSplit/TopBar/HBoxContainer/ScoreLabel
@onready var time_label = $VerticalSplit/TopBar/HBoxContainer/TimeLabel
@onready var game_state = $GameState
@onready var food_manager = $FoodManager

var grid_width = 20
var grid_height = 13

func _ready():
	# 1. КОНФИГУРИРАМЕ КОМПОНЕНТИТЕ НА ИГРАТА
	game_state.player = player
	game_state.score_label = score_label
	game_state.time_label = time_label
	game_state.food_manager = food_manager

	food_manager.player = player
	food_manager.grid_width = grid_width
	food_manager.grid_height = grid_height

	# 2. КОНФИГУРИРАМЕ PLAYER И НЕГОВИТЕ ВЪТРЕШНИ КОМПОНЕНТИ
	player.grid_bounds = Vector2(grid_width, grid_height)
	player.start_position = Vector2(5 * Global.TILE_SIZE, 3 * Global.TILE_SIZE)
	
	var player_movement = player.get_node("PlayerMovement")
	var player_body = player.get_node("PlayerBody")
	
	player_movement.game_state = game_state
	player_movement.body_manager = player_body # Подаваме body_manager на movement_manager

	# 3. СВЪРЗВАМЕ СИГНАЛИТЕ
	player.food_eaten.connect(game_state._on_player_food_eaten)
	game_state.round_ended.connect(_on_round_ended)

	# 4. СТАРТИРАМЕ ИГРАТА
	game_state.start_new_round()

func _on_round_ended():
	print("ROUND OVER! TIME FOR UPGRADES!")
	await get_tree().create_timer(2.0).timeout
	game_state.start_new_round()
