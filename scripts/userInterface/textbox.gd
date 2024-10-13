class_name TextBox

extends CanvasLayer

@export var textLabel: Label

func _ready() -> void:
	pass

var textTween: Tween
func display(text: String, read_rate):
	textLabel.text = text

	textTween = get_tree().create_tween()
	visible = true
	textLabel.visible_ratio = 0
	textTween.tween_property(textLabel, "visible_ratio", 1, len(textLabel.text) / read_rate).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)

func skip():
	if textTween.is_running():
		textTween.kill()
		textLabel.visible_ratio = 1
	else:
		disappear()
	
func disappear() -> void:
	visible = false
	Global.interacting = false

func open() -> bool:
	return visible