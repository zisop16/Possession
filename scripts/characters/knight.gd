class_name Knight

extends BasicMover

func _ready() -> void:
	super._ready()
	Global.player_character = self

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
	if self != Global.player_character:
		return

	handle_questionblock_collision()
	handle_spirits_animation()




var question_event = false
var target_pos: Vector2
var animation_start: float
var zoom_start: float = .5
var zooming = false
var absorbed_spirits = false
var zoom_tween: Tween

func handle_questionblock_collision():
	if not absorbed_spirits:
		var count = get_slide_collision_count()
		for i in count:
			var coll = get_slide_collision(i)
			var obj = coll.get_collider()
			var is_question = obj == Global.question_block
			var from_below = coll.get_normal() == Vector2.DOWN
			if is_question and from_below:
				Global.question_block.release()
				question_event = true
				target_pos = Global.question_block.global_position + Vector2(0, 30)
				animation_start = Global.time
				absorbed_spirits = true
				break

func possess():
	Global.camera.rotation = rotation

func handle_spirits_animation():
	if question_event:
		if not animating and is_on_floor():
			animating = true
			velocity = Vector2.ZERO
			
		if not zooming and ((Global.time - animation_start) > zoom_start):
			zoom_tween = create_tween()
			var zoom_value = 6
			var zoom_duration = 2
			zoom_tween.tween_property(Global.camera, "zoom", Vector2(zoom_value, zoom_value), zoom_duration)
			zoom_tween.set_ease(zoom_tween.EASE_IN)
			Global.camera.custom_center = Global.player_character
			zooming = true

		# var drag_coeff = 5
		# velocity.x -= velocity.x * get_physics_process_delta_time() * drag_coeff

func on_spirits_absorbed():
	Global.reset_camera()
	zoom_tween.kill()
	animating = false
	question_event = false
	Global.possession_unlocked = true
	Global.spirit_meter = 1
