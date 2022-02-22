extends CanvasLayer

@export_node_path(Label) var label_coins
@export_node_path(Label) var label_time
@export_node_path(Label) var label_score

func _ready() -> void:
	get_node(label_coins).text = "Collected Coins: %d" % Globals.coins
	get_node(label_time).text = "Time: %.2f" % Globals.elapsed_time
	get_node(label_score).text = "Total Score: %d" % (Globals.coins * 1000 + int(1200 - Globals.elapsed_time) * 100)
