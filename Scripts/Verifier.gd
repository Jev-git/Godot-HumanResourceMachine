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
				if _aiOutputs[0] != 4 or _aiOutputs[1] != 2 or _aiOutputs[2] != 0:
					return false
		4:
			if aiInputs.size() != _aiOutputs.size():
				return false
			else:
				for iBox in range(0, aiInputs.size(), 2):
					if aiInputs[iBox] != _aiOutputs[iBox + 1] or aiInputs[iBox + 1] != _aiOutputs[iBox]:
						return false
		6:
			if aiInputs.size() / 2 != _aiOutputs.size():
				return false
			else:
				for iBox in range(_aiOutputs.size()):
					if aiInputs[iBox * 2] + aiInputs[iBox * 2 + 1] != _aiOutputs[iBox]:
						return false
		7:
			var iNonZeroCount: int = 0
			for iInput in aiInputs:
				if iInput != 0:
					iNonZeroCount += 1
			if iNonZeroCount != _aiOutputs.size():
				return false
			else:
				var iInput: int = 0
				var iOutput: int = 0
				while iInput < aiInputs.size() and iOutput < _aiOutputs.size():
					if aiInputs[iInput] != 0:
						if aiInputs[iInput] == _aiOutputs[iOutput]:
							iOutput += 1
						else:
							return false
					iInput += 1
		8:
			if aiInputs.size() != _aiOutputs.size():
				return false
			else:
				for iBox in range(aiInputs.size()):
					if aiInputs[iBox] * 3 != _aiOutputs[iBox]:
						return false
		_:
			print_debug("Level is not implemented")
	return true
