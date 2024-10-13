extends Interactable

const sign1 = Vector2i(8, 3)
const sign2 = Vector2i(8, 4)
var has_been_read = false
@onready var outline = $Sprite2D.material
@export_multiline var text: String
@export var read_rate: float

func interact() -> void:
	indicate_interaction(false)
	Global.set_interaction_target(null)
	Global.textbox.display(text, read_rate)

const OUTLINE_WIDTH: float = .004
func indicate_interaction(flag: bool) -> void:
	if flag:
		outline.set_shader_parameter("outline_width", OUTLINE_WIDTH)
	else:
		outline.set_shader_parameter("outline_width", 0)
	