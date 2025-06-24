# Food.gd
extends Area2D

var food_type = 0
var effect = {}

func _ready():
	# Ensure the food is in the "food" group for easy management
	add_to_group("food")
