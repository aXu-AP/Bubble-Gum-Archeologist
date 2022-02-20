class_name LevelTemplate
extends Node2D


@export var default_music := ""
@export var default_variant := 0

func _ready() -> void:
	Globals.current_level = self
	play_music(default_music, default_variant)
	$Camera/Camera2D.current = true


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
