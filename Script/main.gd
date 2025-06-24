# main.gd (Новата, изчистена версия)
extends Node2D

# Референции към всички основни обекти и компоненти
@onready var player = $Player
@onready var game_ui = get_parent().get_parent().get_parent().get_node("GameUi")
@onready var game_state = $GameState
@onready var food_manager = $FoodManager
@onready var upgrade_screen_scene = preload("res://Scene/UpgradeScreen.tscn")
var upgrade_screen_instance = null

# Настройките на света остават тук.
var grid_width = 20
var grid_height = 13
var obstacles = []
var max_obstacles = 5

# Функция за генериране на случайни препятствия
func generate_obstacles():
	obstacles.clear()
	var obstacle_count = randi() % (max_obstacles + 1) # Случаен брой препятствия между 0 и max_obstacles
	for i in range(obstacle_count):
		var obstacle_pos = Vector2(randi() % int(grid_width), randi() % int(grid_height))
		# Уверете се, че препятствието не е твърде близо до началната позиция на змията
		while obstacle_pos.distance_to(Vector2(5, 3)) < 3 or obstacle_pos in obstacles:
			obstacle_pos = Vector2(randi() % int(grid_width), randi() % int(grid_height))
		obstacles.append(obstacle_pos)
	# Тук може да се добави визуализация на препятствията чрез TileMap или отделни обекти
	print("Generated obstacles at positions: ", obstacles)

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

	# 4. ГЕНЕРИРАМЕ ПРЕПЯТСТВИЯ:
	generate_obstacles()
	
	# 5. СТАРТИРАМЕ ИГРАТА:
	game_state.start_new_round()
	
# Тази функция се извиква, когато играчът избере подобрение от екрана за подобрения.
func _on_upgrade_selected(upgrade):
	print("Upgrade selected: ", upgrade["name"])
	# TODO: Приложи ефекта на избраното подобрение към играта или змията.
	# Например, ако е "Speed Up", намали move_speed на играча.
	# Засега просто започваме нов рунд.
	game_state.start_new_round()

# Тази функция се извиква, когато GameState излъчи сигнал "round_ended".
func _on_round_ended():
	print("ROUND OVER! TIME FOR UPGRADES!")
	# Инстанцираме и показваме екрана за подобрения
	if upgrade_screen_instance == null:
		upgrade_screen_instance = upgrade_screen_scene.instantiate()
		add_child(upgrade_screen_instance)
		upgrade_screen_instance.upgrade_selected.connect(_on_upgrade_selected)
	upgrade_screen_instance.show_upgrade_screen()
