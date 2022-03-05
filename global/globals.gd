extends Node

var current_level
var current_level_packed
var flags := {}
@onready var checkpoint_flags = flags
var elapsed_time := 0.0
var coins := 0
var checkpoint_coins := 0
var record := 0


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	flags["not_finished"] = true
	load_game()


func load_and_change_level(level : String, parameter = null):
	current_level_packed = load(level)
	save_game()
	change_level()


func change_level() -> void:
#	get_tree().change_scene(level)
	var parent = get_tree().root
	if is_instance_valid(current_level):
		parent = current_level.get_parent()
		current_level.queue_free()
	var new_level = current_level_packed.instantiate()
	parent.add_child(new_level)
	checkpoint_flags = flags.duplicate()
	checkpoint_coins = coins


func restart_level() -> void:
	flags = checkpoint_flags.duplicate()
	coins = checkpoint_coins
	change_level()


func get_camera_zoom() -> float:
	var camera : Camera2D = get_tree().get_nodes_in_group("current_camera")[0]
	return camera.zoom.x


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause") and current_level != null:
		get_tree().paused = not get_tree().paused
		if get_tree().paused:
			var pause_menu = load("res://ui/pause.tscn").instantiate()
			add_child(pause_menu)
	
	if flags.has_all(["spike_ceiling", "gap", "walljump", "climb", "walljump"]):
		flags["not_finished"] = false
	
	
	if current_level != null and not get_tree().paused:
		elapsed_time += delta


func reset_game() -> void:
	flags = {}
	flags["not_finished"] = true
	elapsed_time = 0
	coins = 0


func save_game(path = "user://savegame.dat") -> void:
	var file = File.new()
	file.open(path, File.WRITE)
	var savedata = {
		flags = flags,
		elapsed_time = elapsed_time,
		coins = coins
	}
	file.store_string(var2str(savedata))


func load_game(path = "user://savegame.dat"):
	var file = File.new()
	if file.file_exists(path):
		file.open(path, File.READ)
		var savedata = str2var(file.get_as_text())
		flags = savedata.flags
		elapsed_time = savedata.elapsed_time
#		coins = savedata.coins
