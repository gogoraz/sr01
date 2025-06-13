# PlayerBody.gd
extends Node

var body_segment_scene = preload("res://Scene/body_segment.tscn")
var body_segments = []
var segments_to_add = 0

func move_body(head_position: Vector2):
	if body_segments.is_empty():
		if segments_to_add > 0:
			_add_segment(head_position)
			segments_to_add -= 1
		return

	var last_segment_pos = head_position
	for segment in body_segments:
		var current_segment_pos = segment.position
		segment.position = last_segment_pos
		last_segment_pos = current_segment_pos
	
	if segments_to_add > 0:
		_add_segment(last_segment_pos)
		segments_to_add -= 1

func create_initial_body(length: int, head_position: Vector2, move_direction: Vector2):
	for i in range(length):
		var new_segment = body_segment_scene.instantiate()
		new_segment.position = head_position - move_direction * (i + 1) * Global.TILE_SIZE
		body_segments.append(new_segment)
		get_parent().get_parent().add_child(new_segment)

func _add_segment(at_position: Vector2):
	var new_segment = body_segment_scene.instantiate()
	new_segment.position = at_position
	body_segments.append(new_segment)
	get_parent().get_parent().add_child(new_segment)

func reset():
	for segment in body_segments:
		if is_instance_valid(segment):
			segment.queue_free()
	body_segments.clear()
	segments_to_add = 0

func get_cells():
	var cells = []
	for segment in body_segments:
		cells.append(segment.position / Global.TILE_SIZE)
	return cells
