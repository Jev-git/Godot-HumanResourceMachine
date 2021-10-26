extends Node

export var m_psBox: PackedScene
export var m_iDistanceBetweenBoxes: int = 64

onready var m_nInstructions: Node2D = NodeUtil.get_first_node_in_group("Instructions")
onready var m_nPlayer: Node2D = NodeUtil.get_first_node_in_group("Player")
onready var m_nLeftConveyor: Node2D = NodeUtil.get_first_node_in_group("LeftConveyor")
onready var m_nRightConveyor: Node2D = NodeUtil.get_first_node_in_group("RightConveyor")
onready var m_nHoldingBox: Box = null

signal error(_sError)

func _ready():
	var aiInputs: Array = [1, 2, 3]
	for iInput in range(aiInputs.size()):
		var nBox: Box = m_psBox.instance()
		nBox.set_value(aiInputs[iInput])
		nBox.position.y = iInput * m_iDistanceBetweenBoxes
		m_nLeftConveyor.add_child(nBox)

func execute():
	for nInstruction in m_nInstructions.get_children():
		match nInstruction.m_iInstructionType:
			InstructionType.INSTRUCTION_TYPE.INBOX:
				get_next_input()
			InstructionType.INSTRUCTION_TYPE.OUTBOX:
				output_holding_value()
			_:
				assert(false)

func get_next_input():
	if m_nLeftConveyor.get_child_count() == 0:
		emit_signal("error", "Input empty")
	else:
		m_nHoldingBox = m_nLeftConveyor.get_child(0)
		m_nLeftConveyor.remove_child(m_nHoldingBox)
		for iBox in range(m_nLeftConveyor.get_child_count()):
			m_nLeftConveyor.get_child(iBox).position.y = iBox * m_iDistanceBetweenBoxes

func output_holding_value():
	if !m_nHoldingBox:
		emit_signal("error", "Can't output nothing")
	else:
		m_nRightConveyor.add_child(m_nHoldingBox)
		m_nRightConveyor.move_child(m_nHoldingBox, 0)
		m_nHoldingBox = null
		for iBox in range(m_nRightConveyor.get_child_count()):
			m_nRightConveyor.get_child(iBox).position.y = iBox * m_iDistanceBetweenBoxes
