extends CanvasLayer

func _ready() -> void:
	Global.post_process_shader = $ColorRect.material