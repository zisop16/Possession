class_name QuestionBlock

extends AnimatableBody2D

@onready var anim_player = $"../AnimationPlayer"
var spirit = preload("res://scenes/spirit.tscn")

func _ready() -> void:
	Global.question_block = self

func _process(_delta: float) -> void:
	var max_spirits = 20
	if released and spirits_released < max_spirits:
		var curr_time = Time.get_ticks_msec() / 1000.
		var time_delta = curr_time - release_time
		var curve_value = s_curve(time_delta)
		var percent_released = spirits_released / float(max_spirits)

		if curve_value > percent_released:
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
			Global.game.add_child(inst)
			spirits_released += 1

func release_spirit():
	var inst: Spirit = spirit.instantiate()
	inst.velocity = Vector2.from_angle(randf_range(0, PI)) * 200
	inst.attractor = Global.player_character
	add_child(inst)
	spirits_released += 1

# With k=10, a=14, this function peaks around x=2 to a value of y=~1
func s_curve(x):
	var k = 1.5
	var a = 4
	var variable_part = 1 / (1 + exp(-(k * x - a)))
	var constant_part = -1/(1+exp(a))

	return variable_part + constant_part


var released = false
var release_time: float
var spirits_released = 0
func release() -> void:
	if released:
		reset()
		return
	anim_player.play("Release")
	released = true
	release_time = Time.get_ticks_msec() / 1000.

func reset() -> void:
	released = false
	spirits_released = 0
	release_time = 0