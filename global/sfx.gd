extends Node

var sounds := {}
var audio_players := []

func _ready() -> void:
	for i in 10:
		var new_player = AudioStreamPlayer2D.new()
		add_child(new_player)
		audio_players.append(new_player)


func play_sfx(name : String, position : Vector2, pitch := 1.0, volume_linear = 1.0, pitch_variation := .1):
	if volume_linear > 0.01:
		for a in audio_players:
			if not a.playing:
				a.stream = get_sfx(name)
				a.global_position = position
				a.pitch_scale = pitch + randf_range(-pitch_variation, pitch_variation)
				volume_linear *= clamp(1 - Globals.get_camera_zoom(), .05, 1.0)
				a.volume_db = linear2db(volume_linear)
#				a.max_distance = 700 * Globals.get_camera_zoom()
				a.play()
				break


func get_sfx(name : String) -> AudioStream:
	var bank = sounds.get(name)
	if bank == null:
		bank = []
		sounds[name] = bank
		var path = "res://sound/"
		var dir = Directory.new()
		dir.open(path)
		dir.list_dir_begin()
		while true:
			var file_name = dir.get_next()
			
			if file_name == "":
				break
			elif file_name.match(name + "*.wav"):
				bank.append(ResourceLoader.load(path + file_name, "AudioStreamSample"))
		dir.list_dir_end()
	return bank[randi() % bank.size()]
