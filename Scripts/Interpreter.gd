extends Node2D

onready var m_nInstructions: Node2D = NodeUtil.get_first_node_in_group("Instructions")
onready var m_nLeftConveyor: Node2D = NodeUtil.get_first_node_in_group("LeftConveyor")
onready var m_nRightConveyor: Node2D = NodeUtil.get_first_node_in_group("RightConveyor")
onready var m_nMemoryFloor: Node2D = NodeUtil.get_first_node_in_group("MemoryFloor")
onready var m_nPlayerHoldingBox: Node2D = NodeUtil.get_first_node_in_group("PlayerHoldingBox")

onready var m_nVerifier: Verifier = get_parent().get_node("Verifier")
onready var m_aiOutputs: Array = []

onready var m_nInstructionPointer: Node2D = NodeUtil.get_first_node_in_group("InstructionPointer")
onready var m_iInstructionPointerIndex: int = 0

signal execution_finished(_bSuccess)
signal error(_sError)

func _ready():
	connect("execution_finished", self, "_on_execution_finished")
	connect("error", self, "_on_error_raised")

func _on_execution_finished(_bSuccess: bool):
	print("Execution finished. Success: %s" % _bSuccess)

func _on_error_raised(_sError: String):
	print("Error: %s" % _sError)

func execute():
	m_nInstructionPointer.visible = true
	while m_iInstructionPointerIndex < m_nInstructions.get_child_count():
		var nInstruction: Instruction = m_nInstructions.get_child(m_iInstructionPointerIndex)
		match nInstruction.m_iInstructionType:
			InstructionType.INSTRUCTION_TYPE.INBOX:
				if (execute_inbox()): return
			InstructionType.INSTRUCTION_TYPE.OUTBOX:
				if (execute_outbox()): return
				elif m_nVerifier.is_correct_solution(m_aiOutputs):
					emit_signal("execution_finished", true)
					return
			InstructionType.INSTRUCTION_TYPE.JUMP:
				_set_instruction_pointer_index(m_iInstructionPointerIndex + 1)
				_set_instruction_pointer_index(nInstruction.m_nJumpTarget.get_index() - 1)
				continue
		
		yield(get_tree().create_timer(0.5), "timeout")
		_set_instruction_pointer_index(m_iInstructionPointerIndex + 1)
		yield(get_tree().create_timer(0.5), "timeout")
	emit_signal("execution_finished", m_nVerifier.is_correct_solution(m_aiOutputs))

func _set_instruction_pointer_index(_iIndex: int):
	m_iInstructionPointerIndex = _iIndex
	m_nInstructionPointer.position.y = _iIndex * ConfigData.DISTANCE_BETWEEN_INSTRUCTIONS

func execute_inbox():
	if m_nLeftConveyor.get_child_count() == 0:
		emit_signal("error", "Input empty")
		return true
	else:
		if m_nPlayerHoldingBox.get_child_count() == 1:
			m_nPlayerHoldingBox.get_child(0).queue_free()
		var nBox: Box = m_nLeftConveyor.get_child(0)
		m_nLeftConveyor.remove_child(nBox)
		m_nPlayerHoldingBox.add_child(nBox)
		
		for iBox in range(m_nLeftConveyor.get_child_count()):
			m_nLeftConveyor.get_child(iBox).position.y = iBox * ConfigData.DISTANCE_BETWEEN_BOXES
		return false

func execute_outbox():
	if m_nPlayerHoldingBox.get_child_count() == 0:
		emit_signal("error", "Can't output nothing")
		return true
	else:
		var nBox: Box = m_nPlayerHoldingBox.get_child(0)
		m_nPlayerHoldingBox.remove_child(nBox)
		m_nRightConveyor.add_child(nBox)
		m_aiOutputs.append(nBox.m_iValue)
		for iBox in range(m_nRightConveyor.get_child_count()):
			m_nRightConveyor.get_child(iBox).position.y = (m_nRightConveyor.get_child_count() - iBox - 1) * ConfigData.DISTANCE_BETWEEN_BOXES
		return false