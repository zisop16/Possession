class_name Slime

extends BasicMover

@export var slime_vision: Color = Color(1, 1, 1, 1)

func left_direction() -> Vector2:
	return up_direction.rotated(-PI/2)

func right_direction() -> Vector2:
	return up_direction.rotated(PI/2)

func _physics_process(delta: float) -> void:
	rotated = false
	super._physics_process(delta)

func left_colliding():
	return left_1.is_colliding() || left_2.is_colliding()

func right_colliding():
	return right_1.is_colliding() || right_2.is_colliding()

func floor_distance() -> float:
	var p1 = null
	var p2 = null
	if down_1.is_colliding():
		p1 = down_1.get_collision_point() - global_position
	if down_2.is_colliding():
		p2 = down_2.get_collision_point() - global_position
	var downComponent = INF
	if p1 != null:
		downComponent = p1.dot(-up_direction)
	if p2 != null:
		downComponent = minf(p2.dot(-up_direction), downComponent)
	return downComponent - slime_bottom.position.length()
	

func before_slide():
	super.before_slide()
	

	if not close_to_floor():
		if (mostRecentMovement == 1) and (left_colliding()):
			# Moving right, fell and have a wall on left
			up_direction = right_direction()
			rotate(PI/2)
			rotated = true
		elif (mostRecentMovement == -1) and (right_colliding()):
			up_direction = left_direction()
			rotate(-PI/2)
			rotated = true
		if rotated:
			update_raycasts()
	
func close_to_floor() -> bool:
	var epsilon = 1
	var dist = floor_distance()
	return dist < epsilon

var mostRecentMovement: float
var rotated: bool
@onready var left_1: RayCast2D = $Left1
@onready var left_2: RayCast2D = $Left2
@onready var right_1: RayCast2D = $Right1
@onready var right_2: RayCast2D = $Right2
@onready var down_1: RayCast2D = $Down1
@onready var down_2: RayCast2D = $Down2
func update_raycasts() -> void:
	left_1.force_raycast_update()
	left_2.force_raycast_update()
	right_1.force_raycast_update()
	right_2.force_raycast_update()
	down_1.force_raycast_update()
	down_2.force_raycast_update()

@onready var slime_bottom: Node2D = $SlimeBottom

func move(direction: float):
	if is_on_wall() and mostRecentMovement != 0:
		if mostRecentMovement == 1:
			# Moving right, ran into a wall
			up_direction = left_direction()
			rotate(-PI/2)
		else:
			# Moving left, ran into a wall
			up_direction = right_direction()
			rotate(PI/2)
		rotated = true
		if rotated:
			update_raycasts()
	
	if rotated:
		var dist = floor_distance()
		if dist != INF:
			global_position += dist * -up_direction

		mostRecentMovement = 0
	else:
		mostRecentMovement = direction

	var horizontal_speed = velocity.dot(right_direction())
	var target = direction * SPEED
	var diff = target - horizontal_speed
	velocity += diff * right_direction()
	change_sprite_direction(direction)
	

func color_difference(col1: Color, col2: Color) -> float:
	return abs(col1.r - col2.r) + abs(col1.g - col2.g) + abs(col1.b - col2.b)

var color_changing = false
func _process(_delta: float) -> void:
	# var click = Input.get_action_strength("Possess")
	super._process(_delta)
	# if is_controlled() and color_changing:
	# 	handle_transition()
	# possess()

func possess() -> void:
	Global.player_character = self
	color_changing = true
			

func handle_transition() -> void:
	var current_color = Global.post_process_shader.get_shader_parameter("filter")
	const change_speed = 1.5;
	var new_color = lerp(current_color, slime_vision, change_speed * get_process_delta_time())
	var diff = color_difference(new_color, slime_vision)
	if diff < .1:
		color_changing = false
		new_color = slime_vision
	Global.post_process_shader.set_shader_parameter("filter", new_color)
	
