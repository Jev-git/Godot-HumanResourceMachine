extends Area2D
class_name Instruction

export var m_iInstructionType: int

onready var m_bIsDragging: bool = false
var m_vGrabOffset: Vector2

signal started_dragging(_self)
signal dropped

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.is_pressed():
			m_bIsDragging = true
			m_vGrabOffset = get_global_mouse_position() - position
			emit_signal("started_dragging", self)

func _input(event):
	if event is InputEventMouseButton:
		if !event.is_pressed() and m_bIsDragging:
			m_bIsDragging = false
			emit_signal("dropped")

func _process(delta):
	if m_bIsDragging:
		position = get_global_mouse_position() - m_vGrabOffset
