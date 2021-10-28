extends Node2D
class_name Room

export var m_iCurrentLevel: int = 1
export var m_psBox: PackedScene
export var m_iMemoryAddressPerRow: int = 4

onready var m_nLeftConveyor: Node2D = NodeUtil.get_first_node_in_group("LeftConveyor")
onready var m_nMemoryFloor: Node2D = NodeUtil.get_first_node_in_group("MemoryFloor")

func _ready():
	randomize()
	
	var aiInputs: Array = _get_inputs(m_iCurrentLevel)
	for iInput in range(aiInputs.size()):
		var nBox: Box = m_psBox.instance()
		nBox.set_value(aiInputs[iInput])
		nBox.position.y = iInput * ConfigData.DISTANCE_BETWEEN_BOXES
		m_nLeftConveyor.add_child(nBox)
	m_nLeftConveyor.cache_initial_inputs()
	
	var aiMemoryData: Array = _get_memory_data(m_iCurrentLevel)
	for iMemory in range(aiMemoryData.size()):
		var nBox: Box = m_psBox.instance()
		nBox.set_value(aiMemoryData[iMemory])
		nBox.position.x = iMemory % m_iMemoryAddressPerRow * ConfigData.DISTANCE_BETWEEN_BOXES
		nBox.position.y = iMemory / m_iMemoryAddressPerRow * ConfigData.DISTANCE_BETWEEN_BOXES
		m_nMemoryFloor.add_child(nBox)

func _get_inputs(_iLevel: int) -> Array:
	var aiInputs: Array = []
	match _iLevel:
		1, 2:
			for __ in range(3):
				aiInputs.append(randi() % 10)
		3:
			aiInputs = [69, 69, 69, 69]
	return aiInputs

func _get_memory_data(_iLevel: int) -> Array:
	var aiMemory: Array = []
	match _iLevel:
		3:
			aiMemory = [0, 1, 2, 3, 4, 5]
	return aiMemory