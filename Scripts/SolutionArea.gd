extends Node2D

export var m_iSpaceBetweenInstructions: int = 48

onready var m_nSourceInstructions: Node2D = get_parent().get_node("SourceInstructions")
onready var m_nInstructions: Node2D = $Instructions
var m_rSolutionAreaRect: Rect2
var m_nDraggingSourceInstruction: SourceInstruction

func _ready():
	var vSolutionAreaSize: Vector2 = $Sprite.texture.get_size() * $Sprite.scale
	var vSolutionAreaPos: Vector2 = position - vSolutionAreaSize / 2
	m_rSolutionAreaRect = Rect2(vSolutionAreaPos, vSolutionAreaSize)
	
	for nSrcIns in m_nSourceInstructions.get_children():
		nSrcIns.connect("started_dragging", self, "_on_source_instruction_started_dragging")
		nSrcIns.connect("dropped", self, "_on_source_instruction_dropped")

func _process(delta):
	if m_nDraggingSourceInstruction:
		var vMousePos: Vector2 = get_global_mouse_position()
		if m_rSolutionAreaRect.has_point(vMousePos):
			var iPlaceHolderIndex: int = (vMousePos.y - m_nInstructions.global_position.y) / m_iSpaceBetweenInstructions
			for iInstruction in range(m_nInstructions.get_child_count()):
				if iInstruction < iPlaceHolderIndex:
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

func _add_instruction(_psInstruction: PackedScene):
	var nInstruction: Instruction = _psInstruction.instance()
	nInstruction.position = Vector2(0, m_nInstructions.get_child_count() * m_iSpaceBetweenInstructions)
	m_nInstructions.add_child(nInstruction)
