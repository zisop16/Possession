class_name QuestionBlock

extends AnimatableBody2D

@onready var anim_player = $"../AnimationPlayer"
var spirit = preload("res://scenes/spirit.tscn")

func _ready() -> void:
	Global.question_block = self


var last_release = 0
func _process(_delta: float) -> void:
	var curr_time = Time.get_ticks_msec() / 1000
	if released:
		if curr_time - last_release > .5:
			last_release = curr_time
			var inst: Spirit = spirit.instantiate()
			inst.velocity = Vector2.from_angle(randf_range(0, PI)) * 200
			inst.attractor = Global.player_character
			add_child(inst)


var released = false
func release() -> void:
	if released:
		return
	anim_player.play("Release")
	released = true
