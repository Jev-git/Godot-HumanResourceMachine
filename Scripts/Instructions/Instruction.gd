extends Area2D
class_name Instruction

export var m_psMemoryAddressPicker: PackedScene

export var m_iInstructionType: int
export var m_bHasJumpTarget: bool = false
export var m_bHasMemoryAddressPicker: bool = false
var m_nJumpSource: Instruction
var m_nJumpTarget: Instruction
var m_nMemoryAddressPicker: MemoryAddressPicker

onready var m_bIsDragging: bool = false
var m_vGrabOffset: Vector2

signal started_dragging(_self)
signal dropped

func _ready():
	if m_bHasMemoryAddressPicker:
		var nMAP: MemoryAddressPicker = m_psMemoryAddressPicker.instance()
		nMAP.position.x = ($Sprite.texture.get_size() * $Sprite.scale).x \
						+ ConfigData.DISTANCE_BETWEEN_INSTRUCTION_AND_MEMORY_ADDRESS_PICKER
		add_child(nMAP)
		m_nMemoryAddressPicker = nMAP

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
			if m_bHasMemoryAddressPicker:
				m_nMemoryAddressPicker.recalculate_rect()
			emit_signal("dropped")

func _process(delta):
	if m_bIsDragging:
		position = get_global_mouse_position() - m_vGrabOffset
