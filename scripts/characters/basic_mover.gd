class_name BasicMover

extends Controllable

func move(direction: float):
	velocity.x = direction * SPEED
	change_sprite_direction(direction)

@export var interaction_range = 0
func can_interact(other: Interactable) -> bool:
	var distance = (other.global_position - global_position).length()
	return distance < interaction_range

func handle_UI_inputs():
	if Input.is_action_just_pressed("Skip"):
		if Global.textbox.open():
			Global.textbox.skip()

func determine_interaction_target() -> Interactable:
	for interactable: Interactable in Global.interactables:
		if can_interact(interactable):
			return interactable
	return null
			
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
		
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	var moving = false
	if is_controlled() and not Global.interacting:
		moving = handle_character_inputs()

	if not moving:
		velocity.x = move_toward(velocity.x, 0, SPEED)
			
	move_and_slide()