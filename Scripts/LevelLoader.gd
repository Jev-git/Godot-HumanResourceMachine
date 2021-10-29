extends Node2D

const SOURCE_INSTRUCTION_DIR = "res://Scenes/SourceInstructions"
const SOURCE_INSTRUCTION_SCENES = [
	preload("res://Scenes/SourceInstructions/Inbox_SourceInstruction.tscn"),		# 0
	preload("res://Scenes/SourceInstructions/Outbox_SourceInstruction.tscn"),		# 1
	preload("res://Scenes/SourceInstructions/Jump_SourceInstruction.tscn"),			# 2
	null,																			# 3
	preload("res://Scenes/SourceInstructions/CopyFrom_SourceInstruction.tscn"),		# 4
	preload("res://Scenes/SourceInstructions/CopyTo_SourceInstruction.tscn"),		# 5
	preload("res://Scenes/SourceInstructions/Add_SourceInstruction.tscn"),			# 6
	preload("res://Scenes/SourceInstructions/JumpIfZero_SourceInstruction.tscn")	# 7
]

export var m_iCurrentLevel: int = 1
export var m_psBox: PackedScene
export var m_iMemoryAddressPerRow: int = 4

onready var m_nLevelDescription: Label = get_parent().get_node("LevelDescription")
onready var m_nSourceInstructions: Node2D = NodeUtil.get_first_node_in_group("SourceInstructions")
onready var m_nLeftConveyor: Node2D = NodeUtil.get_first_node_in_group("LeftConveyor")
onready var m_nRightConveyor: Node2D = NodeUtil.get_first_node_in_group("RightConveyor")
onready var m_nMemoryFloor: Node2D = NodeUtil.get_first_node_in_group("MemoryFloor")
onready var m_nAddressMarkers: Node2D = m_nMemoryFloor.get_parent().get_node("AddressMarkers")

func _ready():
	randomize()
	
	var aiSourceInstructions: Array = _get_source_instructions(m_iCurrentLevel)
	for iSrcIns in range(aiSourceInstructions.size()):
		var nSrcIns: SourceInstruction = SOURCE_INSTRUCTION_SCENES[aiSourceInstructions[iSrcIns]].instance()
		nSrcIns.position.y = iSrcIns * ConfigData.DISTANCE_BETWEEN_INSTRUCTIONS
		m_nSourceInstructions.add_child(nSrcIns)
	
	m_nLevelDescription.text = _get_description(m_iCurrentLevel)
	
	var aiInputs: Array = _get_inputs(m_iCurrentLevel)
	for iInput in range(aiInputs.size()):
		var nBox: Box = m_psBox.instance()
		nBox.set_value(aiInputs[iInput])
		nBox.position.y = iInput * ConfigData.DISTANCE_BETWEEN_BOXES
		m_nLeftConveyor.add_child(nBox)
	m_nLeftConveyor.cache_initial_inputs()
	m_nRightConveyor.cache_desired_outputs(_get_desired_outputs(m_iCurrentLevel, aiInputs))
	
	var aiMemoryData: Array = _get_memory_data(m_iCurrentLevel)
	for iMemory in range(aiMemoryData.size()):
		var nBox: Box = m_psBox.instance()
		nBox.m_iMemoryAddress = iMemory
		nBox.set_value(aiMemoryData[iMemory])
		nBox.position.x = iMemory % m_iMemoryAddressPerRow * ConfigData.DISTANCE_BETWEEN_BOXES
		nBox.position.y = iMemory / m_iMemoryAddressPerRow * ConfigData.DISTANCE_BETWEEN_BOXES
		m_nMemoryFloor.add_child(nBox)
		m_nAddressMarkers.get_child(iMemory).visible = true

func _get_source_instructions(_iLevel: int) -> Array:
	var aiSourceInstructions: Array = []
	match _iLevel:
		1:
			aiSourceInstructions = [
				InstructionType.INSTRUCTION_TYPE.INBOX,
				InstructionType.INSTRUCTION_TYPE.OUTBOX
			]
		2:
			aiSourceInstructions = [
				InstructionType.INSTRUCTION_TYPE.INBOX,
				InstructionType.INSTRUCTION_TYPE.OUTBOX,
				InstructionType.INSTRUCTION_TYPE.JUMP
			]
		3:
			aiSourceInstructions = [
				InstructionType.INSTRUCTION_TYPE.INBOX,
				InstructionType.INSTRUCTION_TYPE.OUTBOX,
				InstructionType.INSTRUCTION_TYPE.COPY_FROM
			]
		4:
			aiSourceInstructions = [
				InstructionType.INSTRUCTION_TYPE.INBOX,
				InstructionType.INSTRUCTION_TYPE.OUTBOX,
				InstructionType.INSTRUCTION_TYPE.COPY_FROM,
				InstructionType.INSTRUCTION_TYPE.COPY_TO,
				InstructionType.INSTRUCTION_TYPE.JUMP
			]
		6, 8:
			aiSourceInstructions = [
				InstructionType.INSTRUCTION_TYPE.INBOX,
				InstructionType.INSTRUCTION_TYPE.OUTBOX,
				InstructionType.INSTRUCTION_TYPE.COPY_FROM,
				InstructionType.INSTRUCTION_TYPE.COPY_TO,
				InstructionType.INSTRUCTION_TYPE.ADD,
				InstructionType.INSTRUCTION_TYPE.JUMP
			]
		7, 9:
			aiSourceInstructions = [
				InstructionType.INSTRUCTION_TYPE.INBOX,
				InstructionType.INSTRUCTION_TYPE.OUTBOX,
				InstructionType.INSTRUCTION_TYPE.COPY_FROM,
				InstructionType.INSTRUCTION_TYPE.COPY_TO,
				InstructionType.INSTRUCTION_TYPE.JUMP,
				InstructionType.INSTRUCTION_TYPE.JUMP_IF_ZERO
			]
	return aiSourceInstructions

func _get_description(_iLevel: int) -> String:
	match _iLevel:
		1:
			return "Send all boxes from the left to the right"
		2:
			return "Send all boxes from the left to the right, but you now can use JUMP!!!"
		3:
			return "Output: [4, 2, 0]"
		4:
			return "Output each pair of boxes in reverse order"
		6:
			return "Output the sum of each pair of boxes from inputs"
		7:
			return "Output all NON-zero boxes"
		8:
			return "Triple each input value and send them to the output"
		9:
			return "Output all zero boxes"
		_:
			return "This level is not implemented yet"

func _get_inputs(_iLevel: int) -> Array:
	var aiInputs: Array = []
	match _iLevel:
		1, 2:
			for __ in range(3):
				aiInputs.append(randi() % 20)
		3:
			aiInputs = [69, 69, 69, 69]
		4, 6:
			for __ in range(8):
				aiInputs.append(randi() % 20)
		7, 9:
			for __ in range(4):
				aiInputs.append(randi() % 20)
			for __ in range(4):
				aiInputs.insert(randi() % aiInputs.size(), 0)
		8:
			for __ in range(4):
				aiInputs.append(randi() % 3 - 1)
	return aiInputs

func _get_desired_outputs(_iLevel: int, _aiInputs: Array) -> Array:
	var aiOutputs: Array = []
	match _iLevel:
		1, 2:
			aiOutputs = _aiInputs.duplicate()
		3:
			aiOutputs = [4, 2, 0]
		4:
			var iInputIndex: int = 0
			while iInputIndex < _aiInputs.size():
				aiOutputs.append(_aiInputs[iInputIndex + 1])
				aiOutputs.append(_aiInputs[iInputIndex])
				iInputIndex += 2
		6:
			var iInputIndex: int = 0
			while iInputIndex < _aiInputs.size():
				aiOutputs.append(_aiInputs[iInputIndex] + _aiInputs[iInputIndex + 1])
				iInputIndex += 2
		7:
			for iInputValue in _aiInputs:
				if iInputValue != 0:
					aiOutputs.append(iInputValue)
		8:
			for iInputValue in _aiInputs:
				aiOutputs.append(iInputValue * 3)
		9:
			for iInputValue in _aiInputs:
				if iInputValue == 0:
					aiOutputs.append(iInputValue)
	return aiOutputs

func _get_memory_data(_iLevel: int) -> Array:
	var aiMemory: Array = []
	match _iLevel:
		3:
			aiMemory = [0, 1, 2, 3, 4, 5]
		4, 6, 8:
			aiMemory = [69, 69, 69]
	return aiMemory
