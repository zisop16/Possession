class_name Controllable

extends CharacterBody2D

@export var SPEED: float = 0
@export var JUMP_SPEED: float = 0
@export var possession_range: float = 0
@export var spirit: PackedScene

@onready var sprite = $AnimatedSprite2D

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

func activate_possession(target: Controllable):
	var inst = release_spirit(target)
	Global.camera.custom_center = inst
	var callback = func():
		Global.player_character = target
		Global.reset_camera()
		target.possess()
	inst.spirit_freed.connect(callback)

func release_spirit(target: Controllable) -> Spirit:
	var inst: Spirit = spirit.instantiate()
	var angle = randf_range(0, 2 * PI)
	angle = (target.global_position - global_position).angle()
	var variance = PI/15
	angle = randf_range(angle - variance, angle + variance)
	angle = Vector2.from_angle(angle)
	var initial_speed = 40
	inst.velocity = angle * initial_speed
	inst.attractor = target
	inst.position = self.global_position
	inst.position += angle * 10
	Global.current_level.add_child(inst)
	return inst
