class_name Slime

extends BasicMover

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var click = Input.get_action_strength("Possess")
	var game = $".."
	if (click == 1):
		game.player_character = $"."
