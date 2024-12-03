class_name TextBox

extends CanvasLayer

@export var textLabel: Label
@export var endLabel: Label

func _ready() -> void:
	pass

var textTween: Tween

var animating: bool = false
var endTime: float

var remaining_messages: Array[String]
var current_read_rate: float

func display(messages: Array[String], read_rate: float):
	remaining_messages = messages.duplicate()
	remaining_messages.reverse()

	var text = remaining_messages.pop_back()
	current_read_rate = read_rate

	display_text(text)

func display_text(text: String):

	textLabel.text = text

	textTween = get_tree().create_tween()
	visible = true
	textLabel.visible_ratio = 0
	textTween.tween_property(textLabel, "visible_ratio", 1, len(textLabel.text) / current_read_rate).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	animating = true
	endLabel.text = ''
	var callback = func():
		animating = false
		endLabel.text = 'v'
		endTime = Time.get_unix_time_from_system()
		endLabelY = endLabel.position.y

	textTween.tween_callback(callback)


var endLabelY: float
func _physics_process(_delta: float) -> void:
	if not animating:
		var currTime = Time.get_unix_time_from_system()
		var diff = currTime - endTime
		var oscillation_height = 16
		var oscillation_speed = 8
		# Make the 'v' at the end of the textbox oscillate up and down from its initial position
		endLabel.position.y = endLabelY - .5 * oscillation_height * (1 - cos(diff * oscillation_speed))

func skip():
	if textTween.is_running():
		textTween.pause()
		textTween.custom_step(100)
		textTween.stop()
	else:
		var next_message = remaining_messages.pop_back()
		if next_message != null:
			display_text(next_message)
		else:
			disappear()
	
func disappear() -> void:
	visible = false
	Global.interacting_object = null

func open() -> bool:
	return visible
