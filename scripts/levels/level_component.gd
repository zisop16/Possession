class_name LevelComponent

extends Node2D

func _ready() -> void:
	Global.current_level = get_parent()

@onready var level_bottom: Node2D = $"../Bottom"
func _physics_process(_delta: float) -> void:
	if Global.player_character == null || level_bottom == null:
		return
	if Global.player_character.global_position.y > level_bottom.global_position.y:
		Global.game_over()
