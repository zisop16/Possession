class_name PlayerCamera
extends Camera2D

# Called when the node enters the scene tree for the first time.
@onready var focus_obj = Global.question_block;
func _ready() -> void:
	pass



func _physics_process(delta: float) -> void:
	var player = Global.player_character
	var target_position = player.global_position + Vector2(0, -20)
	
	var diff = target_position - global_position
	
	
	const lerpFactor = 4
	var change = lerpFactor * diff * delta
	global_position += change

func update_focus() -> void:
	var focusRelativePosition = focus_obj.global_position - global_position
	var cameraDimensions = get_viewport_rect().size
	cameraDimensions.x /= zoom.x
	cameraDimensions.y /= zoom.y
	var focusUV = Vector2(focusRelativePosition.x / cameraDimensions.x, focusRelativePosition.y / cameraDimensions.y)
	focusUV.x += .5
	focusUV.y += .5
	Global.focus_shader.set_shader_parameter("focus", focusUV)
	
