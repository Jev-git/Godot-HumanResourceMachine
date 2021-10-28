extends Area2D
class_name Box

var m_iValue: int

signal pressed(_nSelf)

func set_value(_iValue: int):
	m_iValue = _iValue
	$Label.text = String(m_iValue)

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.is_pressed():
			emit_signal("pressed", self)
