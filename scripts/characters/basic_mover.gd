class_name BasicMover

extends Controllable

func move(direction: float):
	velocity.x = direction * SPEED
	change_sprite_direction(direction)

func can_interact(other: Interactable) -> bool:
	var distance = (other.global_position - global_position).length()
	return distance < interaction_range

var interacting = false
@export var interaction_range = 0
func handle_inputs():
	if interacting:
		return

	if Input.is_action_just_pressed("Interact"):
		for interactable in Global.interactables:
			if can_interact(interactable):
				interacting = true
				interactable.interact()
				break

	if interacting:
		return

	if Input.is_action_just_pressed("Jump") and is_on_floor():
			velocity.y = -JUMP_SPEED
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("Move Left", "Move Right")
	if direction:
		move(direction)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if is_controlled():
		handle_inputs()
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
			
	move_and_slide()