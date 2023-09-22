extends Line2D

func _ready():
	pass
	#var points = PackedVector2Array([Vector2(0,0), Vector2(800, 400)])
	#set_path(points, 20)
	
func set_path(p_points: PackedVector2Array, p_speed: float=10.0, p_offset: float=10.0):
	points = offset(p_points, p_offset)
	material.set_shader_parameter("speed", p_speed)
	
func offset(p_points: PackedVector2Array, p_offset: float=10.0) -> PackedVector2Array:
	if p_points.size() < 2:
		return PackedVector2Array()
		
	var offseted_points := PackedVector2Array()
	
	var s := p_points.size()
	for i in range(s):
		var offset_vector: Vector2
		if i == 0:
			var v := p_points[i].direction_to(p_points[i + 1])
			v = v.orthogonal()
			offset_vector = v * p_offset
		elif i == s - 1:
			var v = p_points[i - 1].direction_to(p_points[i])
			v = v.orthogonal()
			offset_vector =  v * p_offset
		else:
			var v1 := p_points[i - 1].direction_to(p_points[i])
			var v2 = p_points[i].direction_to(p_points[i + 1])
			v1 = v1.orthogonal()
			v2 = v2.orthogonal()
			var alpha = v1.angle_to(v2)
			var v = (v1 + v2).normalized()
			offset_vector = v * p_offset / cos(alpha / 2.0)
			
		offseted_points.append(p_points[i] - offset_vector)
	
	return offseted_points
		
		
