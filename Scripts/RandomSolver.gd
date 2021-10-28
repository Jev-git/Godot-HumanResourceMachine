extends Node2D
class_name RandomSolver

export var m_iNumberOfRandomCheck: int = 3

onready var m_nVerifier: Verifier = NodeUtil.get_first_node_in_group("Verifier")
onready var m_nInstructions: Node2D = NodeUtil.get_first_node_in_group("Instructions")

var m_aiOriginalInputs: Array
var m_aiInputs: Array
var m_aiOutputs: Array
var m_aiMemory: Array
var m_bIsHoldingValue: bool
var m_iHoldingValue: int

func is_correct_solution(_iLevel: int) -> bool:
	for __ in range(m_iNumberOfRandomCheck):
		m_aiOriginalInputs = m_nVerifier.get_random_inputs(_iLevel)
		m_aiInputs = m_aiOriginalInputs.duplicate()
		m_aiOutputs.clear()
		m_bIsHoldingValue = false
		
		var iInstructionIndex: int = 0
		while iInstructionIndex < m_nInstructions.get_child_count():
			var nInstruction: Instruction = m_nInstructions.get_child(iInstructionIndex)
			match nInstruction.m_iInstructionType:
				InstructionType.INSTRUCTION_TYPE.INBOX:
					if (get_next_input()):
						return false
				InstructionType.INSTRUCTION_TYPE.OUTBOX:
					if (output_holding_value()):
						return false
					if m_nVerifier.is_correct_solution(_iLevel, m_aiOriginalInputs, m_aiOutputs):
						return true
				InstructionType.INSTRUCTION_TYPE.JUMP:
					iInstructionIndex = nInstruction.m_nJumpTarget.get_index() - 1
					continue
			
			iInstructionIndex += 1
		
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

func copy_value_from_memory(_iMemoryAddress: int) -> bool:
	if _iMemoryAddress > m_aiMemory.size() - 1:
		print_debug("Error: Copy from invalide memory address")
		return true
	else:
		m_iHoldingValue = m_aiMemory[_iMemoryAddress]
		m_bIsHoldingValue = true
		return false
