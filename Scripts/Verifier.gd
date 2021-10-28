extends Node2D
class_name Verifier

onready var m_nDataLoader: Node2D = get_parent().get_node("DataLoader")
onready var m_nLeftConveyor: Node2D = NodeUtil.get_first_node_in_group("LeftConveyor")

func is_correct_solution(_aiOutputs: Array) -> bool:
	var aiInputs: Array = m_nLeftConveyor.m_aiInitialInputs
	match m_nDataLoader.m_iCurrentLevel:
		1, 2:
			if aiInputs.size() != _aiOutputs.size():
				return false
			else:
				for iBox in range(aiInputs.size()):
					if aiInputs[iBox] != _aiOutputs[iBox]:
						return false
		3:
			if _aiOutputs.size() != 3:
				return false
			else:
				if _aiOutputs[0] != 4 or _aiOutputs[1] != 2 or _aiOutputs[2] == 0:
					return false
	return true
