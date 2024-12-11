class_name Controllable

extends CharacterBody2D

@export var SPEED: float = 0
@export var JUMP_SPEED: float = 0
var possession_range: float = 40
@export var spirit: PackedScene

@onready var sprite = $AnimatedSprite2D
@onready var collision_shape = $CollisionShape2D

func _ready() -> void:
	Global.controllables.append(self)

func _physics_process(_delta: float) -> void:
	if not (Global.possession_unlocked and is_controlled()):
		return
	var target = find_possession_target()
	if target == null:
		return
	if Input.is_action_just_pressed("Possess"):
		activate_possession(target)
	
	

func find_possession_target() -> Controllable:
	var target: Controllable = null
	var lowestDist = 0
	for controllable in Global.controllables:
		if controllable == self:
			continue
		var dist = (controllable.global_position - global_position).length()
		if dist < possession_range:
			if target == null:
				target = controllable
				lowestDist = dist
			elif dist < lowestDist:
				target = controllable
				lowestDist = dist
	return target

func change_sprite_direction(direction: float) -> void:
	if direction == -1:
		sprite.flip_h = true
	else:
		sprite.flip_h = false

func is_controlled() -> bool:
	return Global.player_character == self

func possess():
	pass

@onready var explosion_particles: GPUParticles2D = $Explode
func explode() -> void:
	explosion_particles.emitting = true
	sprite.visible = false
	set_collision_layer_value(1, false)
	set_collision_layer_value(2, false)
	set_collision_layer_value(3, false)

var spirit_active: bool = false

func activate_possession(target: Controllable):
	var inst = release_spirit(target)
	Global.camera.custom_center = inst
	var callback = func():
		Global.player_character = target
		Global.reset_camera()
		target.possess()
		spirit_active = false
		Global.controllables.remove_at(Global.controllables.find(self))
	inst.spirit_freed.connect(callback)
	spirit_active = true
	explode()

func release_spirit(target: Controllable) -> Spirit:
	var inst: Spirit = spirit.instantiate()
	var angle = (target.global_position - global_position).angle()
	var variance = PI/15
	var up = randi_range(0, 1)
	if up:
		angle = angle + PI/3
	else:
		angle = angle - PI/3

	angle = randf_range(angle - variance, angle + variance)
	angle = Vector2.from_angle(angle)
	var initial_speed = 100
	inst.velocity = angle * initial_speed + velocity
	inst.attractor = target
	inst.position = global_position
	inst.position += angle * 10
	Global.current_level.add_child(inst)
	return inst
