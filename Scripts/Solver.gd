extends Node

export var m_psBox: PackedScene
export var m_iDistanceBetweenBoxes: int = 64

onready var m_nVerifier: Verifier = NodeUtil.get_first_node_in_group("Verifier")

onready var m_nInstructions: Node2D = NodeUtil.get_first_node_in_group("Instructions")
onready var m_nPlayer: Node2D = NodeUtil.get_first_node_in_group("Player")
onready var m_nLeftConveyor: Node2D = NodeUtil.get_first_node_in_group("LeftConveyor")
onready var m_nRightConveyor: Node2D = NodeUtil.get_first_node_in_group("RightConveyor")
onready var m_nHoldingBox: Box = null

var m_aiInputs: Array

func execute():
	for nInstruction in m_nInstructions.get_children():
		match nInstruction.m_iInstructionType:
			InstructionType.INSTRUCTION_TYPE.INBOX:
				if (get_next_input()): break
			InstructionType.INSTRUCTION_TYPE.OUTBOX:
				if (output_holding_value()): break
	
	var aiOutputs: Array = []
	for iBox in m_nRightConveyor.get_children():
		aiOutputs.append(iBox.m_iValue)
	print("Specific inputs: %s" % m_nVerifier.is_correct_solution_with_specific_inputs(1, m_aiInputs, aiOutputs))

func get_outputs(_aiInputs: Array) -> Array:
	var aiInputs: Array = m_nVerifier.get_random_inputs(1)
	var aiOutputs: Array = []
	
	return aiOutputs

func get_next_input():
	if m_nLeftConveyor.get_child_count() == 0:
#		emit_signal("error", "Input empty")
		print("Error: Input empty")
		return true
	else:
		m_nHoldingBox = m_nLeftConveyor.get_child(0)
		m_nLeftConveyor.remove_child(m_nHoldingBox)
		for iBox in range(m_nLeftConveyor.get_child_count()):
			m_nLeftConveyor.get_child(iBox).position.y = iBox * m_iDistanceBetweenBoxes
		return false

func output_holding_value():
	if !m_nHoldingBox:
#		emit_signal("error", "Can't output nothing")
		print("Error: Can't output nothing")
		return true
	else:
		m_nRightConveyor.add_child(m_nHoldingBox)
		m_nHoldingBox = null
		for iBox in range(m_nRightConveyor.get_child_count()):
			m_nRightConveyor.get_child(iBox).position.y = (m_nRightConveyor.get_child_count() - iBox - 1) * m_iDistanceBetweenBoxes
		return false
