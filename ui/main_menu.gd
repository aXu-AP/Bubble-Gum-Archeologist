extends Node

@onready var button_start = find_node("ButtonStart")
@onready var button_reset = find_node("ButtonReset")
@onready var button_main_menu = find_node("ButtonMainMenu")
@onready var button_quit = find_node("ButtonQuit")


func _ready() -> void:
	button_start.grab_focus()
	Music.play_music("menu")
	Globals.current_level = null


func _on_button_start_pressed() -> void:
	Globals.load_and_change_level("res://levels/level_hub.tscn")
	queue_free()


func _on_button_reset_pressed() -> void:
	Globals.reset_game()


func _on_button_quit_pressed() -> void:
	get_tree().quit()
