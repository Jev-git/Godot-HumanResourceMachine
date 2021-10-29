extends Node2D

export var m_psBox: PackedScene

onready var m_nInstructions: Node2D = NodeUtil.get_first_node_in_group("Instructions")
onready var m_nLeftConveyor: Node2D = NodeUtil.get_first_node_in_group("LeftConveyor")
onready var m_nRightConveyor: Node2D = NodeUtil.get_first_node_in_group("RightConveyor")
onready var m_nMemoryFloor: Node2D = NodeUtil.get_first_node_in_group("MemoryFloor")
onready var m_nPlayerHoldingBox: Node2D = NodeUtil.get_first_node_in_group("PlayerHoldingBox")

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
				if (_execute_inbox()):
					return
			InstructionType.INSTRUCTION_TYPE.OUTBOX:
				if (_execute_outbox()):
					return
			InstructionType.INSTRUCTION_TYPE.JUMP:
				_set_instruction_pointer_index(m_iInstructionPointerIndex + 1)
				_set_instruction_pointer_index(nInstruction.m_nJumpTarget.get_index())
				continue
			InstructionType.INSTRUCTION_TYPE.COPY_FROM:
				if (_execute_copy_from(nInstruction.m_nMemoryAddressPicker.m_iMemoryAddress)):
					return
			InstructionType.INSTRUCTION_TYPE.COPY_TO:
				if (_execute_copy_to(nInstruction.m_nMemoryAddressPicker.m_iMemoryAddress)):
					return
			InstructionType.INSTRUCTION_TYPE.ADD:
				if (_execute_add(nInstruction.m_nMemoryAddressPicker.m_iMemoryAddress)):
					return
			InstructionType.INSTRUCTION_TYPE.JUMP_IF_ZERO:
				if m_nPlayerHoldingBox.get_child_count() == 0:
					emit_signal("error", "Not holding anything")
					return
				else:
					var iHoldingValue: int = m_nPlayerHoldingBox.get_child(0).m_iValue
					if iHoldingValue == 0:
						_set_instruction_pointer_index(nInstruction.m_nJumpTarget.get_index())
						continue
			
		if m_aiOutputs.size() == m_nRightConveyor.m_aiDesiredOutputs.size() and m_nLeftConveyor.get_child_count() == 0:
			emit_signal("execution_finished", m_aiOutputs == m_nRightConveyor.m_aiDesiredOutputs)
			return
		
		yield(get_tree().create_timer(0.5), "timeout")
		_set_instruction_pointer_index(m_iInstructionPointerIndex + 1)
		yield(get_tree().create_timer(0.5), "timeout")
	emit_signal("execution_finished", m_aiOutputs == m_nRightConveyor.m_aiDesiredOutputs)

func _set_instruction_pointer_index(_iIndex: int):
	m_iInstructionPointerIndex = _iIndex
	m_nInstructionPointer.position.y = _iIndex * ConfigData.DISTANCE_BETWEEN_INSTRUCTIONS

func _execute_inbox() -> bool:
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

func _execute_outbox() -> bool:
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

func _execute_copy_from(_iAddress: int) -> bool:
	if m_nPlayerHoldingBox.get_child_count() == 1:
		m_nPlayerHoldingBox.get_child(0).queue_free()
	var nBox: Box = m_psBox.instance()
	nBox.set_value(m_nMemoryFloor.get_child(_iAddress).m_iValue)
	m_nPlayerHoldingBox.add_child(nBox)
	return false

func _execute_copy_to(_iAddress: int) -> bool:
	if m_nMemoryFloor.get_child_count() < _iAddress:
		emit_signal("error", "Memory address out of bound")
		return true
	elif m_nPlayerHoldingBox.get_child_count() == 0:
		emit_signal("error", "Nothing to write")
		return true
	else:
		m_nMemoryFloor.get_child(_iAddress).set_value(m_nPlayerHoldingBox.get_child(0).m_iValue)
		return false

func _execute_add(_iAddress: int) -> bool:
	if m_nMemoryFloor.get_child_count() < _iAddress:
		emit_signal("error", "Memory address out of bound")
		return true
	elif m_nPlayerHoldingBox.get_child_count() == 0:
		emit_signal("error", "Can't add to nothing")
		return true
	else:
		var iHoldingValue: int = m_nPlayerHoldingBox.get_child(0).m_iValue
		var iFloorValue: int = m_nMemoryFloor.get_child(_iAddress).m_iValue
		m_nPlayerHoldingBox.get_child(0).set_value(iHoldingValue + iFloorValue)
		return false
