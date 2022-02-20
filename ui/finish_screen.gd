extends CanvasLayer

@onready var label_coins = find_node("LabelCoins")
@onready var label_time = find_node("LabelTime")
@onready var label_score = find_node("LabelScore")

func _ready() -> void:
	label_coins.text = "Collected Coins: %d" % Globals.coins
	label_time.text = "Time: %.2f" % Globals.elapsed_time
	label_score.text = "Total Score: %d" % (Globals.coins * 1000 + int(1200 - Globals.elapsed_time) * 100)
