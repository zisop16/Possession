class_name PlayerCamera
extends Camera2D

# Called when the node enters the scene tree for the first time.
@onready var focus_obj = Global.question_block;
var default_zoom = Vector2(4, 4)
var rotation_target: float
func _ready() -> void:
	Global.camera = self
	rotation_target = rotation

func get_center() -> Vector2:
	var center
	if custom_center != null:
		center = custom_center.global_position
	else:
		center = Global.player_character.global_position + Vector2(0, -20)
	return center

func teleport_to_target() -> void:
	var center = get_center()
	global_position = center

var custom_center: Node2D = null

func _process(_delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	var center = get_center()
	
	var diff = center - global_position
	
	
	var lerpFactor = 4
	var change = lerpFactor * diff * delta
	global_position += change

	lerpFactor = 10
	diff = rotation_target - rotation
	change = lerpFactor * diff * delta
	rotation += change

func update_focus() -> void:
	var focusRelativePosition = focus_obj.global_position - global_position
	var cameraDimensions = get_viewport_rect().size
	cameraDimensions.x /= zoom.x
	cameraDimensions.y /= zoom.y
	var focusUV = Vector2(focusRelativePosition.x / cameraDimensions.x, focusRelativePosition.y / cameraDimensions.y)
	focusUV.x += .5
	focusUV.y += .5
	Global.focus_shader.set_shader_parameter("focus", focusUV)
	
