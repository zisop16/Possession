class_name Slime

extends BasicMover

var post_shader: ShaderMaterial = null
@export var slime_vision: Color = Color(1, 1, 1, 1)

func _ready() -> void:
	post_shader = $"../CanvasLayer/ColorRect".material

func color_difference(col1: Color, col2: Color) -> float:
	return abs(col1.r - col2.r) + abs(col1.g - col2.g) + abs(col1.b - col2.b)

var color_changing = false
func _process(delta: float) -> void:
	var click = Input.get_action_strength("Possess")
	var game = $".."
	if (click == 1):
		game.player_character = self
		color_changing = true
	if is_controlled():
		if color_changing:
			var current_color = post_shader.get_shader_parameter("invisibilityColor")
			const change_speed = 1.5;
			var new_color = lerp(current_color, slime_vision, change_speed * delta)
			var diff = color_difference(new_color, slime_vision)
			if diff < .1:
				color_changing = false
				new_color = slime_vision
				print("hi")
			post_shader.set_shader_parameter("invisibilityColor", new_color)
	
