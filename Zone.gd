extends Node2D

@onready var label_out: Label = $LabelOut
@onready var label_in: Label = $LabelIn

var produce: float:
	set(p_value):
		produce = p_value
		label_out.text = str(p_value)
		
var attract: float:
	set(p_value):
		attract = p_value
		label_in.text = str(p_value)
