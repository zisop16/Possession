class_name BasicMover

extends Controllable

func move(direction: float):
	velocity.x = direction * SPEED
	change_sprite_direction(direction)
	
func handle_inputs():
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
			
	move_and_slide()