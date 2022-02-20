extends Area2D

@export var open := true
@export_file("*.tscn") var level
@export var flag := ""
@export var closed_if_flag := true


func _ready() -> void:
	if flag != "" and Globals.flags.get(flag, false):
		open = false

	if not open:
		$Sprite.frame = 1
