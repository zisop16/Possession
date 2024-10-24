class_name Slime

extends BasicMover

@export var slime_vision: Color = Color(1, 1, 1, 1)

func color_difference(col1: Color, col2: Color) -> float:
	return abs(col1.r - col2.r) + abs(col1.g - col2.g) + abs(col1.b - col2.b)

var color_changing = false
func _process(_delta: float) -> void:
	# var click = Input.get_action_strength("Possess")
	pass
	# if is_controlled() and color_changing:
	# 	handle_transition()

func possess() -> void:
	Global.player_character = self
	color_changing = true
			

func handle_transition() -> void:
	var current_color = Global.post_process_shader.get_shader_parameter("filter")
	const change_speed = 1.5;
	var new_color = lerp(current_color, slime_vision, change_speed * get_process_delta_time())
	var diff = color_difference(new_color, slime_vision)
	if diff < .1:
		color_changing = false
		new_color = slime_vision
	Global.post_process_shader.set_shader_parameter("filter", new_color)
	
