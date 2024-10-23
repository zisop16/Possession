class_name BasicMover

extends Controllable

func move(direction: float):
	velocity.x = direction * SPEED
	change_sprite_direction(direction)

@export var interaction_range = 0
func interaction_info(other: Interactable) -> Array:
	var distance = (other.global_position - global_position).length()
	var within_range = distance < interaction_range
	return [within_range, distance]

func handle_UI_inputs():
	if Input.is_action_just_pressed("Skip"):
		if Global.textbox.open():
			Global.textbox.skip()

func determine_interaction_target() -> Interactable:
	var min_dist
	var target = null
	for interactable: Interactable in Global.interactables:
		var info = interaction_info(interactable)
		var can_interact = info[0]
		var curr_dist = info[1]
		if can_interact:
			if target == null:
				min_dist = curr_dist
				target = interactable
				continue
			if curr_dist < min_dist:
				min_dist = range
				target = interactable
	return target
			
func handle_character_inputs() -> bool:

	if Input.is_action_just_pressed("Interact"):
		if Global.interaction_target != null:
			Global.interaction_target.interact()
			Global.interacting = true

	if Global.interacting:
		return false

	if Input.is_action_just_pressed("Jump") and is_on_floor():
			velocity.y = -JUMP_SPEED
	
	var direction = Input.get_axis("Move Left", "Move Right")
	if direction:
		move(direction)

	return direction != 0

func _process(_delta: float) -> void:
	if Global.interacting:
		handle_UI_inputs()
	else:
		Global.set_interaction_target(determine_interaction_target())
		
@onready var sprite = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	var moving = false
	if is_controlled() and not Global.interacting:
		moving = handle_character_inputs()
		if moving:
			sprite.play("run")
		else:
			sprite.play("idle")

	if not moving:
		velocity.x = move_toward(velocity.x, 0, SPEED)
			
	move_and_slide()