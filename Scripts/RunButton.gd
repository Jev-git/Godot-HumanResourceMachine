extends Button

onready var m_nSolver: Node2D = get_parent().get_node("Solver")

func _ready():
	connect("pressed", m_nSolver, "execute")
