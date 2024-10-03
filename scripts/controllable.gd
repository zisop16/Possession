class_name Controllable

extends CharacterBody2D

@export var SPEED = 0
@export var JUMP_SPEED = 0

func change_sprite_direction(direction: float):
	if direction == -1:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false
