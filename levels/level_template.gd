class_name LevelTemplate
extends Node2D


@export var default_music := ""
@export var default_variant := 0
@export var start_position : String


func _ready() -> void:
	Globals.current_level = self
	play_music(default_music, default_variant)
	$Camera/Camera2D.current = true
	var start_pos = get_node_or_null(start_position)
	if start_pos:
		$Player.global_position = start_pos.global_position + Vector2(0, -27)
	$Camera.snap_next_frame()


func play_music(music : String, variant := 0) -> void:
	Music.play_music(music, variant)


func play_explore_0(_area = null) -> void:
	play_music("explore", 0)


func play_explore_1(_area = null) -> void:
	play_music("explore", 1)


func play_explore_2(_area = null) -> void:
	play_music("explore", 2)


func play_panic(_area = null) -> void:
	play_music("panic", 0)


func play_victory(_area = null) -> void:
	play_music("victory", 0)
