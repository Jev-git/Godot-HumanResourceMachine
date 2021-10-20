extends Area2D

onready var m_bIsDragging: bool = false
onready var m_vGrabOffset: Vector2

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		m_bIsDragging = event.is_pressed()
		m_vGrabOffset = get_global_mouse_position() - position

func _process(delta):
	if m_bIsDragging:
		position = get_global_mouse_position() - m_vGrabOffset
