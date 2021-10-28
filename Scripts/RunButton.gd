extends Button

onready var m_nInterpreter: Node2D = get_parent().get_node("Interpreter")

func _ready():
	connect("pressed", m_nInterpreter, "execute")
