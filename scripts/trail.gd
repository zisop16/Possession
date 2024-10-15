extends Line2D

var queue: Array[float]
@export var TRAIL_LENGTH: float = 2
@export var TRAIL_TIMESTEP: float = .001
@export var MIN_TRAIL_DIFF: float = 1

func _process(_delta: float) -> void:
	var pos = linePos()
	
	var time = Time.get_ticks_msec() / 1000.

	if (queue.is_empty()):
		queue.push_front(time)
		add_point(pos)
	else:
		var back_time = queue.back()
		var time_diff = time - back_time
		# If there are 5 points in the queue, point 0 was created at t=0,
		# point 5 created at t=4*timestep, then point 6 can be created after t=5*timestep
		var next_point_time = TRAIL_TIMESTEP * len(queue)
		if time_diff > next_point_time:
			var front_point = get_point_position(len(queue) - 1)
			var pos_diff = pos - front_point
			if pos_diff.length() > MIN_TRAIL_DIFF:
				queue.push_front(time)
				add_point(pos)
			if (Time.get_ticks_msec() % 1000 == 0):
				# print(pos)
				pass
		if time_diff > TRAIL_LENGTH:
			queue.pop_back()
			remove_point(0)

# func _draw() -> void:
# 	var currPos = linePos()
	# draw_circle(currPos, width * 2./5, default_color)

		


func linePos() -> Vector2:
	return get_parent().global_position
