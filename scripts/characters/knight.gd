class_name Knight

extends BasicMover

func _ready() -> void:
	Global.player_character = self

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
	if self == Global.player_character:
		var count = get_slide_collision_count()
		for i in count:
			var coll = get_slide_collision(i)
			var obj = coll.get_collider()
			var is_question = obj == Global.question_block
			var from_below = coll.get_normal() == Vector2.DOWN
			if is_question and from_below:
				Global.question_block.release()
