class_name Spirit

extends Node2D

@onready var trail = $Line2D

@export var attractor: Node2D
@export var gravity_strength: float = .1
@export var drag_factor: float = .1
@export var gravity_exponent: float = 2

func _ready() -> void:
	spawn_time = Time.get_ticks_msec() / 1000.

func gravity_enabled() -> bool:
	var curr_time = Time.get_ticks_msec() / 1000.
	var diff = curr_time - spawn_time
	var gravity_start = .04
	return diff > gravity_start

var velocity = Vector2(0, 0)
var reached_target = false
var spawn_time
func _physics_process(delta: float) -> void:
	var diff = attractor.global_position - global_position
	if reached_target:
		var lerp_speed = 5
		# We want the vector from the attractor to us, which is -diff
		diff *= -1
		var new_diff = lerp(diff.length(), 0., delta * lerp_speed)

		# Gives us a direction for the angular velocity
		# So that the spirit won't turn at a sharp angle when it reaches
		# The target
		var angular_vel = diff.cross(velocity) / 200
		var curr_angle = diff.angle()
		var new_angle = curr_angle + angular_vel * delta
		new_diff = Vector2.from_angle(new_angle) * new_diff

		global_position = attractor.global_position + new_diff
		if len(trail.queue) < 2:
			queue_free()
		return
	if not gravity_enabled():
		position += velocity * delta
		return
	var direction = diff.normalized()
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
