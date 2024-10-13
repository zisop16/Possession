extends Interactable

const sign1 = Vector2i(8, 3)
const sign2 = Vector2i(8, 4)
var has_been_read = false
@onready var outline = $Sprite2D.material
@export_multiline var text: String
@export var read_rate: float

func interact() -> void:
	read()

func read() -> void:
	outline.set_shader_parameter("outline_width", 0)
	Global.textbox.display(text, read_rate)