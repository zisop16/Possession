extends CanvasLayer

func _ready() -> void:
	Global.focus_shader = $ColorRect.material
	visible = false
	Global.focus_effect = self