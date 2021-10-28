extends Node2D

export var m_psJumpTargetInstruction: PackedScene
export var m_iJumpDisplayLeftMargin: int = -4

onready var m_nSourceInstructions: Node2D = get_parent().get_node("SourceInstructions")
onready var m_nInstructions: Node2D = $Instructions

var m_rSolutionAreaRect: Rect2
var m_nDraggingSourceInstruction: SourceInstruction
var m_nDraggingInstruction: Instruction

func _ready():
	var vSolutionAreaSize: Vector2 = $Sprite.texture.get_size() * $Sprite.scale
	var vSolutionAreaPos: Vector2 = position
	m_rSolutionAreaRect = Rect2(vSolutionAreaPos, vSolutionAreaSize)
	
	for nSrcIns in m_nSourceInstructions.get_children():
		nSrcIns.connect("started_dragging", self, "_on_source_instruction_started_dragging")
		nSrcIns.connect("dropped", self, "_on_source_instruction_dropped")

func _draw():
	var iJumpInstructionCount = 0
	for nInstruction in m_nInstructions.get_children():
		if nInstruction.m_nJumpTarget:
			iJumpInstructionCount += 1
			var vSourcePos: Vector2 = nInstruction.position
			var vTargetPos: Vector2 = nInstruction.m_nJumpTarget.position
			draw_line(vSourcePos,
			vSourcePos + Vector2(iJumpInstructionCount * m_iJumpDisplayLeftMargin, 0),
			Color.blue)
			draw_line(vSourcePos + Vector2(iJumpInstructionCount * m_iJumpDisplayLeftMargin, 0),
			vTargetPos + Vector2(iJumpInstructionCount * m_iJumpDisplayLeftMargin, 0),
			Color.blue)
			draw_line(vTargetPos,
			vTargetPos + Vector2(iJumpInstructionCount * m_iJumpDisplayLeftMargin, 0),
			Color.blue)

func _process(delta):
	update()
	if m_rSolutionAreaRect.has_point(get_global_mouse_position()):
		if m_nDraggingSourceInstruction or m_nDraggingInstruction:
			for iInstruction in range(m_nInstructions.get_child_count()):
				var nInstruction = m_nInstructions.get_child(iInstruction)
				if iInstruction < _get_instruction_index_base_on_mouse_pos():
					nInstruction.position.y = iInstruction * ConfigData.DISTANCE_BETWEEN_INSTRUCTIONS
				else:
					nInstruction.position.y = (iInstruction + 1) * ConfigData.DISTANCE_BETWEEN_INSTRUCTIONS

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
	m_nInstructions.remove_child(_nInstruction)
	add_child(_nInstruction)

func _on_instruction_dropped():
	if m_rSolutionAreaRect.has_point(get_global_mouse_position()):
		remove_child(m_nDraggingInstruction)
		m_nInstructions.add_child(m_nDraggingInstruction)
		m_nInstructions.move_child(m_nDraggingInstruction, _get_instruction_index_base_on_mouse_pos())
	else:
		if m_nDraggingInstruction.m_nJumpSource:
			m_nDraggingInstruction.m_nJumpSource.queue_free()
		elif m_nDraggingInstruction.m_nJumpTarget:
			m_nDraggingInstruction.m_nJumpTarget.queue_free()
		m_nDraggingInstruction.queue_free()
	m_nDraggingInstruction = null
	_rearrange_all_instructions()

func _add_instruction(_psInstruction: PackedScene):
	var nInstruction: Instruction = _psInstruction.instance()
	nInstruction.connect("started_dragging", self, "_on_instruction_started_dragging")
	nInstruction.connect("dropped", self, "_on_instruction_dropped")
	m_nInstructions.add_child(nInstruction)
	m_nInstructions.move_child(nInstruction, _get_instruction_index_base_on_mouse_pos())
	if nInstruction.m_bHasJumpTarget:
		_add_jump_instruction_to(nInstruction)
	
func _add_jump_instruction_to(_nInstruction: Instruction):
	var nInstruction: Instruction = m_psJumpTargetInstruction.instance()
	nInstruction.connect("started_dragging", self, "_on_instruction_started_dragging")
	nInstruction.connect("dropped", self, "_on_instruction_dropped")
	m_nInstructions.add_child(nInstruction)
	m_nInstructions.move_child(nInstruction, _get_instruction_index_base_on_mouse_pos())
	
	_nInstruction.m_nJumpTarget = nInstruction
	nInstruction.m_nJumpSource = _nInstruction

func _rearrange_all_instructions():
	for iInstruction in range(m_nInstructions.get_child_count()):
		m_nInstructions.get_child(iInstruction).position = Vector2(0, iInstruction * ConfigData.DISTANCE_BETWEEN_INSTRUCTIONS)

func _get_instruction_index_base_on_mouse_pos() -> int:
	return int((get_global_mouse_position().y - m_nInstructions.global_position.y) / ConfigData.DISTANCE_BETWEEN_INSTRUCTIONS)
