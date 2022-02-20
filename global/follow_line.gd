extends Node2D

@export var top_speed = 150
@export var acceleration_distance = 50
var current_point = 0
var points := []


func _ready() -> void:
	for point in $Line2D.points:
		points.append(to_global(point))
	$Line2D.queue_free()


func _physics_process(delta: float) -> void:
	var from : Vector2 = points[current_point] - global_position
	var speed = min(top_speed, lerp(10, top_speed, inverse_lerp(0, acceleration_distance, from.length())))
	var to : Vector2 = points[(current_point + 1) % points.size()] - global_position
	speed = min(speed, lerp(10, top_speed, inverse_lerp(0, acceleration_distance, to.length())))
	$AudioStreamPlayer2D.volume_db = linear2db(speed / top_speed)
	$AudioStreamPlayer2D.pitch_scale = .7 + (speed / top_speed) * .2
	global_position += to.limit_length(speed * delta)
	
	if to.length_squared() < 4:
		current_point = (current_point + 1) % points.size()
