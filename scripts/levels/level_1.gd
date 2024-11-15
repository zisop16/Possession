extends Node2D

func _ready() -> void:

	# Connect the knight's spirit event handler
	Global.question_block.spirits_finished.connect(Global.player_character.on_spirits_absorbed)
	Global.focus_effect.visible = true