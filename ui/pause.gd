extends CanvasLayer

@export_node_path(Label) var label_coins
@export_node_path(Label) var label_time


func _ready() -> void:
	get_node(label_coins).text = "Coins: %d" % Globals.coins
	get_node(label_time).text = "Time: %.2f" % Globals.elapsed_time


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
