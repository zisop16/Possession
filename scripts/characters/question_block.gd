class_name QuestionBlock

extends AnimatableBody2D

@onready var anim_player = $"../AnimationPlayer"

func _ready() -> void:
	Global.question_block = self

var frame = 0
func _process(_delta: float) -> void:
	frame += 1
	if frame % 100 == 0:
		pass

var released = false
func release() -> void:
	if released:
		return
	anim_player.play("Release")
	released = true
