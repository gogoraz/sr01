# PlayerBody.gd
extends Node

# Променливи, които преди бяха в Player.gd
var body_segment_scene = preload("res://Scene/body_segment.tscn")
var body_segments = []
var segments_to_add = 0

# Тази функция ще се извиква от PlayerMovement.
func move_body(head_position: Vector2):
	if body_segments.is_empty():
		return

	# Местим опашката да последва СТАРАТА позиция на главата.
	var last_segment_pos = head_position
	for segment in body_segments:
		var current_segment_pos = segment.position
		segment.position = last_segment_pos
		last_segment_pos = current_segment_pos
	
	# Добавяме нов сегмент в края, ако е нужно.
	if segments_to_add > 0:
		_add_segment()
		segments_to_add -= 1

func create_initial_body(length: int, head_position: Vector2, move_direction: Vector2):
	for i in range(length):
		var new_segment = body_segment_scene.instantiate()
		new_segment.position = head_position - move_direction * (i + 1) * Global.TILE_SIZE
		body_segments.append(new_segment)
		get_parent().get_parent().add_child(new_segment) # get_parent() два пъти, за да стигнем до Main

func _add_segment():
	var new_segment = body_segment_scene.instantiate()
	if !body_segments.is_empty():
		new_segment.position = body_segments.back().position
	else:
		# Тази логика е малко излишна, но я пазим за всеки случай.
		new_segment.position = get_parent().position
		
	body_segments.append(new_segment)
	get_parent().get_parent().add_child(new_segment)

func reset():
	for segment in body_segments:
		segment.queue_free()
	body_segments.clear()

func get_cells():
	var cells = []
	for segment in body_segments:
		cells.append(segment.position / Global.TILE_SIZE)
	return cells
