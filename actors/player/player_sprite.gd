extends Node2D

@export var has_sound = true

func step_sound():
	if has_sound:
		Sfx.play_sfx("step", global_position, 1, .8)
