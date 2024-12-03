class_name QuestionBlock

extends AnimatableBody2D

signal spirits_finished

@onready var anim_player = $"../AnimationPlayer"
@export var spirit: PackedScene
@export var spiritCurve: Curve
@export var release_endpoint: float = 2

func _ready() -> void:
	Global.question_block = self

var remaining_spirits: int
var max_spirits = 20


var angular_velocity: float = 0

func _process(_delta: float) -> void:
	if not released:
		return
	if spirits_released < max_spirits:
		var curr_time = Time.get_ticks_msec() / 1000.
		var time_delta = curr_time - release_time
		# When time_delta == release_endpoint, we sample the curve at x = 1 -> y = 1
		var curve_value = spiritCurve.sample(time_delta / release_endpoint)
		var percent_released = spirits_released / float(max_spirits)

		if curve_value > percent_released:
			release_spirit()
	if Global.interacting_object == self:
		if remaining_spirits == 0:
			Global.interacting_object = null
			spirits_finished.emit()

	# Global.log("Spirits remaining", remaining_spirits)

func _physics_process(_delta: float) -> void:
	if Global.focus_effect.visible:
		var camera = Global.camera
		var camera_size = get_viewport_rect().size / Global.camera.zoom
		var uvZero = Global.camera.global_position - camera_size / 2
		var uvPosition = (global_position - uvZero) / camera_size
		
		Global.focus_shader.set_shader_parameter("focus", uvPosition)

func release_spirit():
	var inst: Spirit = spirit.instantiate()
	var left = randi_range(0, 1)
	var angle
	var buffer = .2
	if left:
		angle = randf_range(0, (1-buffer) * PI/2)
	else:
		angle = randf_range(PI/2 * (1+buffer), PI)
	# Because angles from 0 -> pi point downwards, and we want
	# to point upwards ;)
	angle *= -1
	angle = Vector2.from_angle(angle)
	var initial_speed = 200
	inst.velocity = angle * initial_speed
	inst.attractor = Global.player_character
	inst.position = self.global_position
	inst.position += angle * 10
	Global.current_level.add_child(inst)
	spirits_released += 1
	var decrement_spirit_count = func(): remaining_spirits -= 1
	inst.spirit_freed.connect(decrement_spirit_count)
	inst.spirit_hit_knight.connect(Global.player_character.spirit_impact)


var released = false
var release_time: float
var spirits_released = 0
func release() -> void:
	if released:
		return
	anim_player.play("Release")
	released = true
	release_time = Time.get_ticks_msec() / 1000.
	Global.interacting_object = self
	remaining_spirits = max_spirits
	Global.focus_effect.visible = false

func reset() -> void:
	released = false
	spirits_released = 0
	release_time = 0
