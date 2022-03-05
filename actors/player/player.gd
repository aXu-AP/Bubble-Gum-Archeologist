class_name Player
extends CharacterBody2D

const max_speed := 150.0
const jump_velocity := -300.0
const acceleration := 700.0
const acceleration_air := 300.0
const deceleration := 2000.0

var target_bubble : Node2D
var is_in_bubble := false
var can_use_bubble := true
var jumping := false
var gravity : int = ProjectSettings.get_setting("physics/2d/default_gravity")
var was_on_floor := 0.0
var was_on_wall := 0.0
var was_jump_pressed := 0.0
var animation_cooldown := 0.0
var invincibility_cooldown := 0.0
var alive = true


func _physics_process(delta: float) -> void:
	if not alive:
		return
	was_on_floor -= delta
	was_on_wall -= delta
	was_jump_pressed -= delta
	animation_cooldown -= delta
	invincibility_cooldown -= delta
	if not is_in_bubble:
		if Input.is_action_just_pressed("enter_door") and is_on_floor():
			var areas = $DoorArea.get_overlapping_areas()
			for door in areas:
				if door.open:
					Globals.load_and_change_level(door.level)
					break
		
		if Input.is_action_just_pressed("jump"):
			was_jump_pressed = .1
		if is_on_floor():
			if was_on_floor < 0:
				$PlayerSprite/AnimationPlayer.stop()
				animate("fall")
				animate("landing", 0.2, 1)
			was_on_floor = .2
			was_on_wall = 0
			can_use_bubble = true
		if is_on_wall_only():
			was_on_wall = .2
		
		if not is_on_floor():
			if motion_velocity.y < 0 and jumping:
				motion_velocity.y += gravity * delta * .5
				if Input.is_action_just_released("jump"):
					motion_velocity.y /= 2.0
			else:
				motion_velocity.y += gravity * delta
			if is_on_wall_only():
				animate("wall_slide", .1)
				look_dir(get_wall_normal().x)
				if motion_velocity.y > 0:
					motion_velocity.y -= motion_velocity.y * delta * 2
			elif motion_velocity.y > -50:
				animate("fall", .3)
		else:
			jumping = false
		
		
		var direction := Input.get_axis("move_left", "move_right")
		if is_on_floor():
			if direction:
				if abs(motion_velocity.x) < 40 and was_on_wall < 0:
					motion_velocity.x = direction * 41
				else:
					motion_velocity.x = move_toward(motion_velocity.x, direction * max_speed, acceleration * delta)
				look_dir(direction)
				animate("walk", .1, abs(motion_velocity.x) / 60)
			else:
				motion_velocity.x = move_toward(motion_velocity.x, 0, deceleration * delta)
				animate("idle", .2)
		else:
			motion_velocity.x = move_toward(motion_velocity.x, direction * max(max_speed, abs(motion_velocity.x)), acceleration_air * delta)
		
		if was_jump_pressed > 0:
			if was_on_floor > 0:
				motion_velocity.y = jump_velocity
				jumping = true
			elif was_on_wall > 0:
				motion_velocity.y = jump_velocity * .9
				motion_velocity += -get_wall_normal() * jump_velocity * .7
				look_dir(motion_velocity.x)
				jumping = true
			if jumping:
				animate("jump", .05)
				was_jump_pressed = 0
				was_on_floor = 0
				was_on_wall = 0
		
		move_and_slide()
		
		if Input.is_action_just_pressed("bubble") and can_use_bubble:
			if is_instance_valid(target_bubble):
				target_bubble.die()
			
			target_bubble = preload("res://actors/bubble/bubble.tscn").instantiate()
			target_bubble.linear_velocity = motion_velocity
			target_bubble.global_position = global_position
			get_parent().add_child(target_bubble)
			is_in_bubble = true
			can_use_bubble = false
			jumping = false
		
		global_rotation = lerp_angle(global_rotation, 0, .1)
	else:
		if is_instance_valid(target_bubble) and target_bubble.alive:
			animate("bubble", .3)
	#		global_position = target_bubble.global_position
			global_transform = target_bubble.global_transform
			motion_velocity = target_bubble.linear_velocity
			if Input.is_action_just_pressed("bubble"):
				burst_bubble()
		else:
			burst_bubble()
	
	if $HurtArea.get_overlapping_areas().size() > 0:
		if is_in_bubble:
			burst_bubble()
			target_bubble.die()
			invincibility_cooldown = .5
		elif invincibility_cooldown < 0:
			alive = false
			animate("die", .6)
			Sfx.play_sfx("dead", global_position)
			var dead_body = RigidDynamicBody2D.new()
			dead_body.global_transform = global_transform
			dead_body.linear_velocity = Vector2(motion_velocity.x * .5, motion_velocity.y - 200)
			dead_body.angular_velocity = randf_range(5, 10) * -sign($PlayerSprite.scale.x)
			var mat = PhysicsMaterial.new()
			mat.friction = .4
			mat.bounce = .4
			dead_body.physics_material_override = mat
			var p = get_parent()
			var col = $CollisionShape2D
			p.remove_child(self)
			remove_child(col)
			dead_body.add_child(self)
			dead_body.add_child(col)
			transform = Transform2D()
			p.add_child(dead_body)
			var timer := get_tree().create_timer(3)
			timer.connect("timeout", Globals.restart_level)


func burst_bubble():
	is_in_bubble = false
	motion_velocity.y = min(0, motion_velocity.y) + jump_velocity
	if is_instance_valid(target_bubble):
		target_bubble.linear_velocity.y -= jump_velocity * .5
		target_bubble.is_player_controlled = false
	move_and_slide()


func animate(animation : String, blend := -1.0, speed := 1.0, cooldown := -1.0) -> void:
	if animation_cooldown < 0:
		$PlayerSprite/AnimationPlayer.play(animation, blend, speed)
		animation_cooldown = cooldown

func look_dir(direction : float):
	$PlayerSprite.scale.x = 0.12 if direction > 0 else -0.12
	
