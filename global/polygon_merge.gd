extends Node2D


@export var template_polygon : PackedScene


func _ready() -> void:
	var polygons := []
	for child in get_children():
		if child is Polygon2D:
			var transformed_polygon = PackedVector2Array()
			for point in child.polygon:
				transformed_polygon.append(child.to_global(point))
			
			if child.is_in_group("remove"):
				if polygons.size() > 0:
					remove_polygon(transformed_polygon, polygons)
			else:
				if polygons.size() == 0:
					polygons.append(transformed_polygon)
				else:
					add_polygon(transformed_polygon, polygons)
	for poly in polygons:
		var new_poly : Polygon2D
		if template_polygon:
			new_poly = template_polygon.instantiate()
		else:
			new_poly = Polygon2D.new()
		new_poly.polygon = poly
#		new_poly.color = Color(randf(), randf(), randf(), .8)
#		new_poly.global_position = Vector2(randf_range(-5, 5), randf_range(-5, 5))
		get_parent().call_deferred("add_child", new_poly)
	queue_free()


func add_polygon(polygon : PackedVector2Array, polygons : Array) -> void:
	var remove_indices := []
	for i in polygons.size():
		var merged = Geometry2D.merge_polygons(polygons[i], polygon)
#					polygons.append_array(merged)
		var j = merged.size()
		while j >= 0:
			j -= 1
			if Geometry2D.is_polygon_clockwise(merged[j]):
				for k in merged.size():
					if not Geometry2D.is_polygon_clockwise(merged[k]):
						merged[k] = poke_hole(merged[k], merged[j])
						merged.remove_at(j)
						break
		if merged.size() == 1:
			polygon = merged[0]
			remove_indices.push_front(i)
	if remove_indices.size() > 0:
		for i in remove_indices:
			polygons.remove_at(i)
	polygons.append(polygon)


func remove_polygon(polygon : PackedVector2Array, polygons : Array) -> void:
	var remove_indices := []
	for i in polygons.size():
		var clipped = Geometry2D.clip_polygons(polygons[i], polygon)
#					polygons.append_array(merged)
		for j in clipped.size():
			if Geometry2D.is_polygon_clockwise(clipped[j]):
				clipped = [poke_hole(clipped[(j - 1) % clipped.size()], clipped[j])]
				break
		remove_indices.push_front(i)
		polygons.append_array(clipped)
	if remove_indices.size() > 0:
		for i in remove_indices:
			polygons.remove_at(i)
#	polygons.append(polygon)


func poke_hole(polygon_a : PackedVector2Array, polygon_b : PackedVector2Array) -> PackedVector2Array:
	var highest_point := -1
	var highest_value := -INF
	var count := polygon_b.size()
	for i in count:
		if polygon_b[i].y > highest_value:
			highest_point = i
			highest_value = polygon_b[i].y
	# TODO: find actual cutting point
	var new_polygon_b = [Vector2(polygon_b[highest_point].x, 200000), polygon_b[highest_point] + Vector2.RIGHT * .0001]
	for i in count:
		new_polygon_b.append(polygon_b[(highest_point + i + 1) % count])
	var clipped = Geometry2D.clip_polygons(polygon_a, PackedVector2Array(new_polygon_b))
#	assert(clipped.size() == 1)
	return clipped[0]
