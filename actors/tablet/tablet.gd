extends Area2D

@export var flag := ""


func _ready() -> void:
	if Globals.flags.get(flag, false):
		queue_free()


func _on_tablet_area_entered(area: Area2D) -> void:
	Globals.flags[flag] = true
	$AnimationPlayer.play("collect")
	$Jingle.play()
