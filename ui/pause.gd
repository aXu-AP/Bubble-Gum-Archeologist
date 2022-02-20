extends CanvasLayer

@onready var button_continue = find_node("ButtonContinue")
@onready var button_reset = find_node("ButtonReset")
@onready var button_main_menu = find_node("ButtonMainMenu")
@onready var button_quit = find_node("ButtonQuit")
@onready var label_coins = find_node("LabelCoins")
@onready var label_time = find_node("LabelTime")


func _ready() -> void:
	button_continue.grab_focus()
	label_coins.text = "Coins: %d" % Globals.coins
	label_time.text = "Time: %.2f" % Globals.elapsed_time


func _process(delta: float) -> void:
	if not get_tree().paused:
		queue_free()


func _on_button_continue_pressed() -> void:
	get_tree().paused = false
	queue_free()


func _on_button_reset_pressed() -> void:
	Globals.restart_level()
	_on_button_continue_pressed()


func _on_button_main_menu_pressed() -> void:
	Globals.load_and_change_level("res://ui/main_menu.tscn")
	_on_button_continue_pressed()


func _on_button_quit_pressed() -> void:
	get_tree().quit()
