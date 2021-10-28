extends Node2D

var m_aiInitialInputs: Array

func cache_initial_inputs():
	m_aiInitialInputs = []
	for nBox in get_children():
		m_aiInitialInputs.append(nBox.m_iValue)
