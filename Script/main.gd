# main.gd (Новата, изчистена версия)
extends Node2D

# Референции към всички основни обекти и компоненти
@onready var player = $Player
@onready var game_ui = $GameUI
@onready var game_state = $GameState
@onready var food_manager = $FoodManager

# Настройките на света остават тук.
var grid_width = 20
var grid_height = 13

# Тази функция се извиква, когато сцената е готова.
func _ready():
	# 1. КОНФИГУРИРАМЕ КОМПОНЕНТИТЕ:
	# Даваме на GameState всичко, от което се нуждае.
	game_state.player = player
	game_state.game_ui = game_ui
	game_state.food_manager = food_manager

	# Даваме на FoodManager всичко, от което се нуждае.
	food_manager.player = player
	food_manager.grid_width = grid_width
	food_manager.grid_height = grid_height
	
	# 2. КОНФИГУРИРАМЕ PLAYER И НЕГОВИТЕ КОМПОНЕНТИ:
	# Даваме на Player всичко, от което се нуждае.
	player.grid_bounds = Vector2(grid_width, grid_height)
	player.start_position = Vector2(5 * Global.TILE_SIZE, 3 * Global.TILE_SIZE)
	
	# Подаваме на компонента за движение референция към game_state.
	player.get_node("PlayerMovement").game_state = game_state
	
	# 3. СВЪРЗВАМЕ СИГНАЛИТЕ:
	# Казваме на GameState да слуша кога играчът яде храна.
	player.food_eaten.connect(game_state._on_player_food_eaten)
	# Казваме на Main да слуша кога GameState обяви край на рунда.
	game_state.round_ended.connect(_on_round_ended)

	# 4. СТАРТИРАМЕ ИГРАТА:
	game_state.start_new_round()

# Тази функция се извиква, когато GameState излъчи сигнал "round_ended".
func _on_round_ended():
	print("ROUND OVER! TIME FOR UPGRADES!")
	# Тук по-късно ще показваме екрана за подобрения.
	# Засега, просто ще започваме нов рунд след 2 секунди за тест.
	await get_tree().create_timer(2.0).timeout
	game_state.start_new_round()
