extends Node2D
class_name Box

var m_iValue: int

func set_value(_iValue: int):
	m_iValue = _iValue
	$Label.text = String(m_iValue)
