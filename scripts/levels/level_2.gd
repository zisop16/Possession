extends Node2D

@onready var start_slime = $StartSlime
func _ready() -> void:
	Global.player_character = start_slime