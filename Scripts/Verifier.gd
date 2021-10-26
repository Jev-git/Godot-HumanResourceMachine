extends Node2D
class_name Verifier

func get_random_inputs(_iLevel: int) -> Array:
	randomize()
	var aiInputs: Array = []
	match _iLevel:
		1:
			for __ in range(3):
				aiInputs.append(randi() % 10)
	return aiInputs

func is_correct_solution(_iLevel: int, _aiInputs: Array, _aiOutputs: Array) -> bool:
	match _iLevel:
		1:
			if _aiInputs.size() != _aiOutputs.size():
				return false
			else:
				for iBox in range(_aiInputs.size()):
					if _aiInputs[iBox] != _aiOutputs[iBox]:
						return false
	return true
