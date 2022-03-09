extends Node


func _ready() -> void:
	Music.play_music("menu")
	Globals.current_level = null


func _on_button_start_pressed() -> void:
	if Globals.flags.get("intro", false):
		Globals.load_and_change_level("res://levels/level_hub.tscn")
	else:
		Globals.load_and_change_level("res://levels/level_intro.tscn")
	queue_free()


func _on_button_reset_pressed() -> void:
	Globals.reset_game()


func _on_button_quit_pressed() -> void:
	get_tree().quit()
