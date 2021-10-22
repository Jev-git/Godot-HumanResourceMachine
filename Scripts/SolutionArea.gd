extends Node2D

export var m_iSpaceBetweenInstructions: int = 48

onready var m_nSourceInstructions: Node2D = get_parent().get_node("SourceInstructions")
onready var m_nInstructions: Node2D = $Instructions

var m_rSolutionAreaRect: Rect2
var m_nDraggingSourceInstruction: SourceInstruction
var m_nDraggingInstruction: Instruction

func _ready():
	var vSolutionAreaSize: Vector2 = $Sprite.texture.get_size() * $Sprite.scale
	var vSolutionAreaPos: Vector2 = position - vSolutionAreaSize / 2
	m_rSolutionAreaRect = Rect2(vSolutionAreaPos, vSolutionAreaSize)
	
	for nSrcIns in m_nSourceInstructions.get_children():
		nSrcIns.connect("started_dragging", self, "_on_source_instruction_started_dragging")
		nSrcIns.connect("dropped", self, "_on_source_instruction_dropped")

func _process(delta):
	if m_nDraggingSourceInstruction or m_nDraggingInstruction:
		var vMousePos: Vector2 = get_global_mouse_position()
		if m_rSolutionAreaRect.has_point(vMousePos):
			for iInstruction in range(m_nInstructions.get_child_count()):
				if iInstruction < _get_instruction_index_base_on_mouse_pos():
					m_nInstructions.get_child(iInstruction).position.y = iInstruction * m_iSpaceBetweenInstructions
				else:
					m_nInstructions.get_child(iInstruction).position.y = (iInstruction + 1) * m_iSpaceBetweenInstructions

func _on_source_instruction_started_dragging(_nSourceInstruction: SourceInstruction):
	m_nDraggingSourceInstruction = _nSourceInstruction

func _on_source_instruction_dropped():
	if m_rSolutionAreaRect.has_point(get_global_mouse_position()):
		_add_instruction(m_nDraggingSourceInstruction.m_psInstruction)
	m_nDraggingSourceInstruction.reset_preview_node()
	m_nDraggingSourceInstruction = null
	_rearrange_all_instructions()

func _on_instruction_started_dragging(_nInstruction: Instruction):
	m_nDraggingInstruction = _nInstruction

func _on_instruction_dropped():
	if !m_rSolutionAreaRect.has_point(get_global_mouse_position()):
		m_nDraggingInstruction.queue_free()
	m_nDraggingInstruction = null
	_rearrange_all_instructions()

func _add_instruction(_psInstruction: PackedScene):
	var nInstruction: Instruction = _psInstruction.instance()
	nInstruction.connect("started_dragging", self, "_on_instruction_started_dragging")
	nInstruction.connect("dropped", self, "_on_instruction_dropped")
	m_nInstructions.add_child(nInstruction)
	m_nInstructions.move_child(nInstruction, _get_instruction_index_base_on_mouse_pos())

func _rearrange_all_instructions():
	for iInstruction in range(m_nInstructions.get_child_count()):
		m_nInstructions.get_child(iInstruction).position = Vector2(0, iInstruction * m_iSpaceBetweenInstructions)

func _get_instruction_index_base_on_mouse_pos() -> int:
	return int((get_global_mouse_position().y - m_nInstructions.global_position.y) / m_iSpaceBetweenInstructions)
