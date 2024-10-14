class_name TextBox

extends CanvasLayer

@export var textLabel: Label
@export var endLabel: Label

func _ready() -> void:
	pass

var textTween: Tween

var animating = false
var endTime: float

func display(text: String, read_rate):
	textLabel.text = text

	textTween = get_tree().create_tween()
	visible = true
	textLabel.visible_ratio = 0
	textTween.tween_property(textLabel, "visible_ratio", 1, len(textLabel.text) / read_rate).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	animating = true
	endLabel.text = ''
	var callback = func():
		animating = false
		endLabel.text = 'v'
		endTime = Time.get_unix_time_from_system()
		endLabelY = endLabel.global_position.y

	textTween.tween_callback(callback)


var endLabelY: float
func _physics_process(_delta: float) -> void:
	if not animating:
		var currTime = Time.get_unix_time_from_system()
		var diff = currTime - endTime
		var oscillation_height = 16
		var oscillation_speed = 8
		# Make the 'v' at the end of the textbox oscillate up and down from its initial position
		endLabel.global_position.y = endLabelY - .5 * oscillation_height * (1 - cos(diff * oscillation_speed))

func skip():
	if textTween.is_running():
		textTween.pause()
		textTween.custom_step(100)
		textTween.stop()
	else:
		disappear()
	
func disappear() -> void:
	visible = false
	Global.interacting = false

func open() -> bool:
	return visible
