extends CharacterBody2D

@export var default_parameters : Resource
@export_node_path(Node2D) var target_area_path
@export_node_path(Node2D) var player_path
@onready var area : Area2D = get_node(target_area_path)
var current_zone : CameraZone
@onready var camera : Camera2D = $Camera2D
var player : Player
var last_player_y = 1000000000
var player_motion_smoothed := Vector2.ZERO

func _ready() -> void:
	default_parameters.target = get_node(default_parameters.target_path)
	player = get_node(player_path)


func _physics_process(_delta: float) -> void:
	var current_priority = 0
	current_zone = null
	for zone in area.get_overlapping_areas():
		if zone is CameraZone and current_priority <= zone.zone_priority:
			current_priority = zone.zone_priority
			current_zone = zone


func _process(delta: float) -> void:
	var params : CameraParameters = default_parameters
	if current_zone:
		params = current_zone.parameters
	
	var s = global_scale.x
	s = lerp(s, params.zoom, .05)
	global_scale = Vector2(s, s)
	camera.zoom = global_scale
	
	if player.is_on_floor() or last_player_y - player.global_position.y < 0 or last_player_y - player.global_position.y > 100:
		last_player_y = player.global_position.y
		
	if params.mode == CameraParameters.CameraMode.fixed:
		motion_velocity = (params.target.global_position + params.offset) - global_position
	elif params.mode == CameraParameters.CameraMode.follow:
		var target_pos = Vector2(player.global_position.x, last_player_y) + params.offset
		var player_motion := Vector2.ZERO
		player_motion.x = max(0, abs(player.motion_velocity.x) - 20) * 1.2 * sign(player.motion_velocity.x)
		player_motion.y = max(0, abs(player.motion_velocity.y) - 400) * 1.2 * sign(player.motion_velocity.y)
		player_motion_smoothed = player_motion_smoothed.lerp(player_motion, .01)
		target_pos += player_motion_smoothed
		motion_velocity = target_pos - global_position
		
	motion_velocity *= 3
	
	move_and_slide()
	
	var screen_margin = (Vector2(1980, 1080) / 2 - Vector2(200, 200)) * global_scale
	var target_move = global_position.clamp(player.global_position - screen_margin, player.global_position + screen_margin) - global_position
	if target_move.length() > 10:
		var keep_motion = motion_velocity
		motion_velocity = target_move * 10
		move_and_slide()
		motion_velocity = keep_motion
