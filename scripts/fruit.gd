extends Interactable

@onready var color_correction = $Sprite2D.material
@export var transport_level: PackedScene

func interact() -> void:
	var position_offset = Vector2(0, -20)
	var final_position = global_position + position_offset

	Global.camera.custom_center = self
	
	var position_tween = create_tween()
	position_tween.tween_property(self, "global_position", final_position, 1.5)
	position_tween.set_ease(position_tween.EASE_OUT)
	position_tween.tween_callback(zoom_in)

func zoom_in():
	var tween = create_tween()
	var duration = 1.3
	tween.tween_method(Global.set_brightness, 0., .8, duration)
	tween.set_ease(tween.EASE_IN)
	tween.set_trans(tween.TRANS_CUBIC)
	tween = tween.parallel()
	tween.tween_property(Global.camera, "zoom", Vector2(100, 100), duration)
	tween.set_ease(tween.EASE_IN)
	tween.set_trans(tween.TRANS_QUINT)
	tween.tween_callback(finish_change)
	

func _process(_delta: float) -> void:
	return
	if Time.get_ticks_msec() % 1000 == 0:
		print(Global.camera.zoom)

func finish_change() -> void:
	Global.load_level(transport_level)
	
var max_brightness = .8
func _physics_process(_delta: float) -> void:
	var player_pos = Global.player_character.global_position
	var distance = (player_pos - global_position).length()
	if distance > interaction_range:
		color_correction.set_shader_parameter("brightness", 0)
		return
	var closeness = 1 - distance / interaction_range
	# Closeness goes from 0 -> 1 as we go from not close to close
	var sine_speed = 5
	var sine_value = .5 * (1 + sin(Time.get_ticks_msec() / 1000. * sine_speed))
	var brightness = closeness * max_brightness * sine_value
	color_correction.set_shader_parameter("brightness", brightness)
		
	

	
