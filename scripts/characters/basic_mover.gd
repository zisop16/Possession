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
	# print(target)
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

enum AI_STATES {
	IDLE,
	CHASING
}

# Current state of AI
var state: AI_STATES = AI_STATES.IDLE
var remaining_movement: float = 0
var movement_direction: float = 0
var next_movement_time: float = 0

func generate_directional_movement() -> void:
	return
	var stdev = 1
	var normal = randfn(0, stdev)
	var stdev_limits = 3
	normal = clamp(normal, -stdev_limits*stdev, stdev_limits*stdev)
	if (normal < 0):
		remaining_movement = -normal
		movement_direction = -1
	else:
		remaining_movement = normal
		movement_direction = 1

# mew is the average
# mewing is important
func exponential_random(mew : float = 1.0) -> float:
	return -log(1.0 - randf()) * mew

func generate_movement_time() -> void:
	var average = 3
	var result = exponential_random(average)
	next_movement_time = result

func afraid_of_moving() -> bool:
	return false

func handle_ai_inputs() -> bool:
	if afraid_of_moving():
		return false

	match state:
		AI_STATES.IDLE:
			if remaining_movement != 0:
				if movement_direction > 0:
					move(1)
				else:
					move(-1)
				remaining_movement -= get_physics_process_delta_time()
				if remaining_movement < 0:
					remaining_movement = 0
				return true

			elif next_movement_time == 0:
				generate_directional_movement()
				generate_movement_time()
			else:
				next_movement_time -= get_physics_process_delta_time()
				if next_movement_time < 0:
					next_movement_time = 0

		AI_STATES.CHASING:
			pass

	return false
		

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


		if not is_controlled():
			moving = handle_ai_inputs()

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
	super._physics_process(_delta)
	before_slide()
			
	move_and_slide()

func _process(_delta: float) -> void:
	if is_controlled() and Global.interacting_object:
		handle_UI_inputs()