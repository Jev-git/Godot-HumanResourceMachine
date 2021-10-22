extends Area2D
class_name SourceInstruction

export var m_psInstruction: PackedScene

onready var m_bIsDragging: bool = false
var m_vGrabOffset: Vector2

onready var m_nPreviewNode: Node2D = $Preview

signal started_dragging(_self)
signal dropped

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.is_pressed():
			m_bIsDragging = true
			m_vGrabOffset = get_global_mouse_position() - global_position
			emit_signal("started_dragging", self)

func _input(event):
	if event is InputEventMouseButton:
		if !event.is_pressed() and m_bIsDragging:
			m_bIsDragging = false
			emit_signal("dropped")

func _process(delta):
	if m_bIsDragging:
		m_nPreviewNode.global_position = get_global_mouse_position() - m_vGrabOffset

func reset_preview_node():
	m_nPreviewNode.global_position = global_position
