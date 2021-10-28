extends Node2D

export var m_iCurrentLevel: int = 1
export var m_psBox: PackedScene
export var m_iDistanceBetweenBoxes: int = 64

var m_aiIntialInputs: Array

onready var m_nRunButton: Button = $RunButton
onready var m_nLeftConveyor: Node2D = $Floor/LeftConveyor/Inputs
onready var m_nRightConveyor: Node2D = $Floor/RightConveyor/Outputs
onready var m_nMemoryFloor: Node2D = $Floor/MemoryFloor/Memory
onready var m_nPlayer: Node2D = $Player

func _ready():
	randomize()
	
	m_nRunButton.connect("pressed", self, "_on_run_button_pressed")
	
	m_aiIntialInputs = _get_random_inputs(m_iCurrentLevel)
	for iInput in range(m_aiIntialInputs.size()):
		var nBox: Box = m_psBox.instance()
		nBox.set_value(m_aiIntialInputs[iInput])
		nBox.position.y = iInput * m_iDistanceBetweenBoxes
		m_nLeftConveyor.add_child(nBox)

func _on_run_button_pressed():
	pass

func _get_random_inputs(_iLevel: int) -> Array:
	var aiInputs: Array = []
	match _iLevel:
		1, 2:
			for __ in range(3):
				aiInputs.append(randi() % 10)
		3:
			aiInputs = [69, 69, 69, 69]
	return aiInputs

func get_random_memory(_iLevel: int) -> Array:
	var aiMemory: Array = []
	match _iLevel:
		3:
			aiMemory = [0, 1, 2, 3, 4, 5]
	return aiMemory

func is_correct_solution(_iLevel: int, _aiInputs: Array, _aiOutputs: Array) -> bool:
	match _iLevel:
		1, 2:
			if _aiInputs.size() != _aiOutputs.size():
				return false
			else:
				for iBox in range(_aiInputs.size()):
					if _aiInputs[iBox] != _aiOutputs[iBox]:
						return false
		3:
			if _aiOutputs.size() != 3:
				return false
			else:
				if _aiOutputs[0] != 4 or _aiOutputs[1] != 2 or _aiOutputs[2] == 0:
					return false
	return true
