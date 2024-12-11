extends Control

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_play_pressed() -> void:
	Global.load_level(0)
