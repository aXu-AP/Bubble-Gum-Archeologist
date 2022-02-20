extends RigidDynamicBody2D

var is_player_controlled := true
@onready var sprite : Node2D = $Polygon2D
@onready var ray_excludes = [self, $Polygon2D/StaticBody2D]
var motion_history := []


func _ready() -> void:
	sprite.global_position = global_position
	for i in 5:
		motion_history.append(linear_velocity)
	Sfx.play_sfx("bubble_make", global_position, 1, .3)


func _physics_process(delta: float) -> void:
	var bounce_force = 30
	if is_player_controlled:
		var direction := Input.get_axis("move_left", "move_right")
		apply_central_force(Vector2.RIGHT * direction * 300)
		if Input.is_action_pressed("jump"):
			bounce_force = 90
	
	var state := get_world_2d().direct_space_state
	var ray := PhysicsRayQueryParameters2D.new()
	ray.from = global_position
	ray.exclude = ray_excludes
	ray.collision_mask = 0b11
	var avg_dis := Vector2.ZERO
	var dis_count := 0
	for i in 16:
		var dir = Vector2.RIGHT.rotated(i * TAU / 16)
		ray.to = ray.from + dir * 32
		var result := state.intersect_ray(ray)
		if result:
			var dis : Vector2 = result.position - ray.to
			apply_force(dis * bounce_force - linear_velocity * .008, result.position - global_position)
			apply_force(linear_velocity * .006, -result.position + global_position)
			avg_dis += dis
			dis_count += 1
	if dis_count > 0:
		avg_dis /= dis_count
		
	if sprite.scale.x > .9:
		sprite.global_rotation = avg_dis.angle()
	else:
		sprite.global_rotation = lerp_angle(sprite.global_rotation, avg_dis.angle(), .2)
	sprite.scale.x = move_toward(sprite.scale.x, (32 - avg_dis.length()) / 32, 1 * delta)
	sprite.scale.y = 1 / sprite.scale.x
	sprite.global_position = global_position + avg_dis * .5
	
	var old_speed : Vector2 = motion_history.pop_front()
	motion_history.append(linear_velocity)
	var change = (old_speed - linear_velocity).length()
	if change > 100:
		Sfx.play_sfx("bubble_boing", global_position, 1, inverse_lerp(100, 1500, change) * 2)
		motion_history.clear()
		for i in 5:
			motion_history.append(linear_velocity)


func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	const max_speed = 30 * 60
	if state.linear_velocity.length() > max_speed:
		state.linear_velocity = state.linear_velocity.normalized() * max_speed


func die():
	$AnimationPlayer.play("die")


func pop_sound():
	Sfx.play_sfx("bubble_pop", global_position)
