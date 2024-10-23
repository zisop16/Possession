extends Node2D


func _ready() -> void:
	Global.logging = false
	Global.textbox = $TextBox
	Global.game = self

var average = 0
var alpha = 0.001
var frames = 0
func _process(delta: float) -> void:
	# Exponentially weighted moving average
	# Keeps track of fps during last ~1000f
	average = average * (1-alpha) + alpha * 1/delta
	frames += 1
	if (Global.logging && frames % 1000 == 0):
		print(average)