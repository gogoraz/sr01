# UpgradeScreen.gd
extends Control

signal upgrade_selected(upgrade)

# Списък с възможни подобрения (бъфове)
var upgrades_pool = [
	{"name": "Speed Up", "effect": {"speed": 0.05}, "description": "Увеличава скоростта на змията с 5%."},
	{"name": "Speed Down", "effect": {"speed": -0.05}, "description": "Намалява скоростта на змията с 5%."},
	{"name": "Shield", "effect": {"buff": "shield"}, "description": "Дава щит за един удар."},
	{"name": "Shorten", "effect": {"length": -2}, "description": "Скъсява змията с 2 сегмента (ако е възможно)."},
	{"name": "More Food", "effect": {"food_count": 1}, "description": "Увеличава броя на храната на полето."},
	{"name": "Cursed Speed", "effect": {"speed": 0.1, "control": -0.1}, "description": "Увеличава скоростта с 10%, но намалява контрола."}
]

var selected_upgrade = null

@onready var upgrade_option_1 = $VBoxContainer/Option1
@onready var upgrade_option_2 = $VBoxContainer/Option2
@onready var upgrade_option_3 = $VBoxContainer/Option3
@onready var description_label = $VBoxContainer/Description

func _ready():
	# Скриваме екрана, докато не бъде извикан
	hide()
	# Свързваме бутоните към функции
	upgrade_option_1.pressed.connect(_on_option_1_pressed)
	upgrade_option_2.pressed.connect(_on_option_2_pressed)
	upgrade_option_3.pressed.connect(_on_option_3_pressed)

func show_upgrade_screen():
	# Избираме 3 случайни подобрения от списъка
	var available_upgrades = upgrades_pool.duplicate()
	available_upgrades.shuffle()
	
	# Настройваме текстовете на бутоните
	if available_upgrades.size() > 0:
		upgrade_option_1.text = available_upgrades[0]["name"]
		upgrade_option_1.set_meta("upgrade", available_upgrades[0])
	if available_upgrades.size() > 1:
		upgrade_option_2.text = available_upgrades[1]["name"]
		upgrade_option_2.set_meta("upgrade", available_upgrades[1])
	if available_upgrades.size() > 2:
		upgrade_option_3.text = available_upgrades[2]["name"]
		upgrade_option_3.set_meta("upgrade", available_upgrades[2])
	
	# Показваме екрана
	show()
	# Показваме описанието на първото подобрение по подразбиране
	if available_upgrades.size() > 0:
		description_label.text = available_upgrades[0]["description"]

func _on_option_1_pressed():
	selected_upgrade = upgrade_option_1.get_meta("upgrade")
	emit_signal("upgrade_selected", selected_upgrade)
	hide()

func _on_option_2_pressed():
	selected_upgrade = upgrade_option_2.get_meta("upgrade")
	emit_signal("upgrade_selected", selected_upgrade)
	hide()

func _on_option_3_pressed():
	selected_upgrade = upgrade_option_3.get_meta("upgrade")
	emit_signal("upgrade_selected", selected_upgrade)
	hide()
