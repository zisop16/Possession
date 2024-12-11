extends Node2D

@export var lev1: PackedScene
@export var lev2: PackedScene
@export var lev0: PackedScene
@export var levmenu: PackedScene

func _ready() -> void:
	Global.textbox = $TextBox
	Global.game = self
	Global.post_process_shader = $PostProcess/ColorRect.material
	Global.camera.custom_center = $"level-1/Center"
	Global.camera.global_position = Global.camera.custom_center.global_position


var average = 0
var alpha = 0.001
var frames = 0
var printed = 0
func _process(delta: float) -> void:
	Global.time = Time.get_ticks_usec() / 1000000.

	# Exponentially weighted moving average
	# Keeps track of fps during last ~1000f
	average = average * (1-alpha) + alpha * 1/delta
	frames += 1
	var should_log = frames != printed and Global.logging and frames % 100 == 0
	if should_log:
		for key in Global.logs.keys():
			print("%s: %s" % [key, Global.logs[key]])
		printed = frames
		# print(average)
	if Global.possession_unlocked:
		Global.spirit_meter += Global.spirit_fill * delta
		Global.spirit_meter = clampf(Global.spirit_meter, 0, 1)
