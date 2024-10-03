class_name PlayerCamera
extends Camera2D

# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	pass



func _physics_process(delta: float) -> void:
	var player = $"..".player_character
	var player_position = player.global_position
	
	var diff = player_position - global_position
	
	
	const lerpFactor = 3
	var change = lerpFactor * diff * delta
	global_position += change
	
	
