extends Node2D
class_name MemoryAddressPicker

export var m_fScaleChange: float = 0.3

onready var m_nMemoryFloor: Node2D = NodeUtil.get_first_node_in_group("MemoryFloor")

onready var m_nSprite: Sprite = $Sprite
onready var m_nLabel: Label = $Label

onready var m_bIsPicking: bool = false
onready var m_iMemoryAddress: int = 0

var m_rRect: Rect2

func _ready():
	m_rRect.size = m_nSprite.texture.get_size() * m_nSprite.scale
	_set_memory_address(m_iMemoryAddress)
	for nBox in m_nMemoryFloor.get_children():
		nBox.connect("pressed", self, "_on_box_selected")

func _on_box_selected(_nBox: Box):
	if m_bIsPicking:
		m_bIsPicking = false
		m_nSprite.set_scale(m_nSprite.scale - Vector2(m_fScaleChange, m_fScaleChange))
		_set_memory_address(_nBox.m_iValue)

func _input(event):
	if event is InputEventMouseButton:
		if event.is_action_released("ui_accept"):
			if m_bIsPicking:
				m_bIsPicking = false
				m_nSprite.set_scale(m_nSprite.scale - Vector2(m_fScaleChange, m_fScaleChange))
			elif m_rRect.has_point(get_global_mouse_position()):
				m_bIsPicking = true
				m_nSprite.set_scale(m_nSprite.scale + Vector2(m_fScaleChange, m_fScaleChange))

func recalculate_rect():
	m_rRect.position = global_position

func _set_memory_address(_iAddress: int):
	m_iMemoryAddress = _iAddress
	m_nLabel.text = String(_iAddress)
