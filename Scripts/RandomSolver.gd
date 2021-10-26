extends Node2D
class_name RandomSolver

export var m_iNumberOfRandomCheck: int = 3

onready var m_nVerifier: Verifier = NodeUtil.get_first_node_in_group("Verifier")
onready var m_nInstructions: Node2D = NodeUtil.get_first_node_in_group("Instructions")

var m_aiOriginalInputs: Array
var m_aiInputs: Array
var m_aiOutputs: Array
var m_bIsHoldingValue: bool
var m_iHoldingValue: int

func is_correct_solution(_iLevel: int) -> bool:
	for __ in range(m_iNumberOfRandomCheck):
		m_aiOriginalInputs = m_nVerifier.get_random_inputs(_iLevel)
		m_aiInputs = m_aiOriginalInputs.duplicate()
		m_aiOutputs.clear()
		m_bIsHoldingValue = false
		
		for nInstruction in m_nInstructions.get_children():
			match nInstruction.m_iInstructionType:
				InstructionType.INSTRUCTION_TYPE.INBOX:
					if (get_next_input()):
						return false
				InstructionType.INSTRUCTION_TYPE.OUTBOX:
					if (output_holding_value()):
						return false
		
		if !m_nVerifier.is_correct_solution(_iLevel, m_aiOriginalInputs, m_aiOutputs):
			return false
	return true

func get_next_input() -> bool:
	if m_aiInputs.size() == 0:
		print_debug("Error: Input empty")
		return true
	else:
		m_iHoldingValue = m_aiInputs.pop_front()
		m_bIsHoldingValue = true
		return false

func output_holding_value() -> bool:
	if !m_bIsHoldingValue:
		print_debug("Error: Can't output nothing")
		return true
	else:
		m_aiOutputs.append(m_iHoldingValue)
		m_bIsHoldingValue = false
		return false
