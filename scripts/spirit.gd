class_name Spirit

extends Node2D

@onready var trail = $Line2D

@export var attractor: Node2D
@export var gravity_strength: float = 4
@export var drag_factor: float = .1
@export var gravity_exponent: float = 1.3


var velocity = Vector2(0, 0)
var reached_target = false
func _physics_process(delta: float) -> void:
	if reached_target:
		if len(trail.queue) == 0:
			queue_free()
		return
	var diff = attractor.global_position - global_position
	var direction = diff.normalized()
	# print(direction)
	var magnitude = pow(diff.length(), gravity_exponent) * gravity_strength
	var accel = magnitude * direction
	velocity += accel * delta
	# Get the component of velocity perpendicular to pull direction
	var parallel_angle = direction.angle() + PI/2
	var parallel_direction = Vector2.from_angle(parallel_angle)
	var parallel_component = velocity.dot(parallel_direction) * parallel_direction



	var drag = -parallel_component * drag_factor
	velocity += drag * delta
	global_position += velocity * delta

	var inside = (global_position - attractor.position).length() < 15
	if inside:
		reached_target = true