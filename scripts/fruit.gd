extends Interactable

@onready var color_correction = $Sprite2D.material

func _physics_process(_delta: float) -> void:
	var max_distance = 50
	var player_pos = Global.player_character.global_position
	var distance = (player_pos - global_position).length()
	if distance > max_distance:
		return
	var closeness = 1 - distance / max_distance
	# Closeness goes from 0 -> 1 as we go from not close to close
	color_correction.set_shader_parameter("brightness", closeness * .8)