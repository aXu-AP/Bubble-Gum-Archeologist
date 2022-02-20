extends Area2D

func _on_coin_area_entered(_area: Area2D) -> void:
	$AnimationPlayer.play("collect")
	$Jingle.play()
	Globals.coins += 1
