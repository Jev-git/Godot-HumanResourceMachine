extends Button

onready var m_nRandomSolver: RandomSolver = NodeUtil.get_first_node_in_group("RandomSolver")
onready var m_nSolver: Node2D = get_parent().get_node("Solver")

func _ready():
	connect("pressed", self, "_check_solution_with_random_inputs")

func _check_solution_with_random_inputs():
	print(m_nRandomSolver.is_correct_solution(1))
