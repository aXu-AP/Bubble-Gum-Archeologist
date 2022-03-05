extends Polygon2D

@export var make_line = true
@export var closed_line = true
@export var one_way = false

func _ready() -> void:
	var collider = CollisionPolygon2D.new()
	collider.polygon = polygon
	collider.transform = transform
	collider.one_way_collision = one_way
	get_parent().call_deferred("add_child", collider)
	
	if make_line:
		var line = Line2D.new()
		var linepoints = polygon
		if closed_line:
			linepoints.append(linepoints[0])
		line.points = linepoints
		line.default_color = Color("000000")
		line.width = 2
		line.z_index = -1
		line.end_cap_mode = Line2D.LINE_CAP_ROUND
		line.joint_mode = Line2D.LINE_JOINT_ROUND
		line.transform = transform
		get_parent().call_deferred("add_child", line)
	
