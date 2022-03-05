@tool
class_name Circle2D
extends Polygon2D

@export var radius := 64.0:
	set(value):
		radius = value
		update_polygon()
@export var step_size := 10.0:
	set(value):
		step_size = value
		update_polygon()


func _ready() -> void:
	update_polygon()


func update_polygon() -> void:
	var verts := []
	var diameter := PI * radius * 2
	var steps := int(diameter / step_size)
	var delta := TAU / steps
	var pos := Vector2(radius, 0)
	for i in steps:
		verts.append(pos)
		pos = pos.rotated(delta)
	polygon = PackedVector2Array(verts)
