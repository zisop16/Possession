class_name Controllable

extends CharacterBody2D

@export var SPEED: float = 0
@export var JUMP_SPEED: float = 0

func change_sprite_direction(direction: float) -> void:
	if direction == -1:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false

func is_controlled() -> bool:
	return $"..".player_character == self