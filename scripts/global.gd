extends Node2D


var interactables: Array[Interactable] = []

var textbox: TextBox = null
var interacting = null
var interaction_target = null
var game: Node2D = null
var camera: PlayerCamera = null

var player_character: Controllable = null
var question_block: QuestionBlock = null
var focus_shader: Material = null
var post_process_shader: Material = null
var logging: bool = false
var current_level: Node2D = null


func set_interaction_target(interactable: Interactable):
	if interactable == interaction_target:
		if interactable != null:
			interactable.indicate_interaction(true)
		return
	if interactable != interaction_target:
		if interactable != null:
			interactable.indicate_interaction(true)
		if interaction_target != null:
			interaction_target.indicate_interaction(false)
		interaction_target = interactable

func reset_camera():
	camera.custom_center = null

var curr_brightness: float = 0
func set_brightness(value: float):
	curr_brightness = value
	post_process_shader.set_shader_parameter("brightness", value)
	
func load_level(level: PackedScene):
	current_level.queue_free()
	interactables.clear()
	var tween = create_tween()
	var duration = .8

	tween.tween_method(set_brightness, curr_brightness, 0., duration)
	tween.set_trans(tween.TRANS_CUBIC)
	tween.set_ease(tween.EASE_IN)
	tween = tween.parallel()
	tween.tween_property(camera, "zoom", camera.default_zoom, duration)
	tween.set_trans(tween.TRANS_CUBIC)
	tween.set_ease(tween.EASE_OUT)
	tween.tween_callback(reset_camera)
	
	interacting = false
	var next_level = level.instantiate()
	game.add_child(next_level)
	camera.custom_center = player_character
	camera.teleport_to_target()