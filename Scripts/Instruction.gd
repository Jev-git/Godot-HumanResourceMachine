extends Area2D
class_name Instruction

onready var m_bIsDragging: bool = false
var m_vGrabOffset: Vector2

onready var m_nSolutionArea: Node2D = get_tree().get_nodes_in_group("SolutionArea")[0]

signal dropped

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.is_pressed():
			m_bIsDragging = true
			m_vGrabOffset = get_global_mouse_position() - position

func _input(event):
	if event is InputEventMouseButton:
		if !event.is_pressed() and m_bIsDragging:
			m_bIsDragging = false
			if !m_nSolutionArea.get_rect().has_point(get_global_mouse_position()):
				queue_free()
			else:
				emit_signal("dropped")

func _process(delta):
	if m_bIsDragging:
		position = get_global_mouse_position() - m_vGrabOffset
