extends CanvasLayer

@onready var score_label = $MarginContainer/HBoxContainer/ScoreLabel
@onready var time_label = $MarginContainer/HBoxContainer/TimeLabel

func update_score(new_score):
	score_label.text = "Score: " + str(new_score)

func update_time(time_left):
	# Използваме ceil(), за да закръглим времето нагоре до цяло число.
	time_label.text = "Time: " + str(ceil(time_left))
