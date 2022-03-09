extends "res://levels/level_template.gd"



func _on_tablet_area_entered(_area: Area2D) -> void:
	$Label.visible = true
	$CameraZone1.process_mode = Node.PROCESS_MODE_INHERIT
