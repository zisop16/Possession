class_name BasicMover

extends Controllable

func move(direction: float):
	velocity.x = direction * SPEED
	change_sprite_direction(direction)

func interaction_info(other: Interactable) -> Array:
	var distance = (other.global_position - global_position).length()
	var within_range = distance < other.interaction_range
	return [within_range, distance]

func handle_UI_inputs():
	if Input.is_action_just_pressed("Skip"):
		if Global.textbox.open():
			Global.textbox.skip()

var animating: bool = false

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
			Global.interacting_object = Global.interaction_target
			Global.interaction_target.interact()

	if Global.interacting_object:
		return false

	if Input.is_action_just_pressed("Jump") and is_on_floor():
			velocity += up_direction * JUMP_SPEED
	
	var direction = Input.get_axis("Move Left", "Move Right")
	if direction != 0:
		move(direction)

	return direction != 0
		
@onready var sprite = $AnimatedSprite2D

func before_slide():
	
	var delta = get_physics_process_delta_time()
	if not animating:
		if not is_on_floor():
			# Add the gravity.
			velocity += get_gravity().length() * -up_direction * delta
			

		# Handle jump.
		var moving = false
		if is_controlled() and not Global.interacting_object:
			Global.set_interaction_target(determine_interaction_target())

			moving = handle_character_inputs()
			if moving:
				sprite.play("run")
			else:
				sprite.play("idle")

		if not moving:
			var horizontal_direction = up_direction.rotated(-PI/2)
			var horizontal_speed = velocity.dot(horizontal_direction)
			var new_horizontal_speed = move_toward(horizontal_speed, 0, SPEED)
			var diff = new_horizontal_speed - horizontal_speed
			velocity += diff * horizontal_direction
			# velocity.x = move_toward(velocity.x, 0, SPEED)

func _physics_process(_delta: float) -> void:
	before_slide()
			
	move_and_slide()

func _process(_delta: float) -> void:
	if is_controlled() and Global.interacting_object:
		handle_UI_inputs()