extends Area2D

onready var m_bIsDragging: bool = false
var m_vGrabOffset: Vector2

onready var m_nPreviewSprite: Sprite = $PreviewSprite
onready var m_nSolutionArea: Sprite = get_tree().get_nodes_in_group("SolutionArea")[0]
var m_rSolutionAreaRect: Rect2

func _ready():
	var vSolutionAreaSize: Vector2 = m_nSolutionArea.texture.get_size() * m_nSolutionArea.scale
	var vSolutionAreaPos: Vector2 = m_nSolutionArea.position - vSolutionAreaSize / 2
	m_rSolutionAreaRect = Rect2(vSolutionAreaPos, vSolutionAreaSize)

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.is_pressed():
			m_bIsDragging = true
			m_vGrabOffset = get_global_mouse_position() - global_position

func _input(event):
	if event is InputEventMouseButton:
		if !event.is_pressed():
			m_bIsDragging = false
			if !m_rSolutionAreaRect.has_point(get_global_mouse_position()):
				m_nPreviewSprite.global_position = position

func _process(delta):
	if m_bIsDragging:
		m_nPreviewSprite.global_position = get_global_mouse_position() - m_vGrabOffset
