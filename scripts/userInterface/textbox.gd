class_name TextBox

extends CanvasLayer

@export var textLabel: Label

func _ready() -> void:
	pass

func display(text: String, read_rate):
	textLabel.text = text

	var tween = get_tree().create_tween()
	visible = true
	textLabel.visible_ratio = 0
	tween.tween_property(textLabel, "visible_ratio", 1, len(textLabel.text) / read_rate).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	
func disappear() -> void:
	visible = false