extends Node

var sounds := {}
var audio_players := []

func _ready() -> void:
	for i in 10:
		var new_player = AudioStreamPlayer2D.new()
		add_child(new_player)
		audio_players.append(new_player)


func play_sfx(sfx_name : String, position : Vector2, pitch := 1.0, volume_linear = 1.0, pitch_variation := .1):
	if volume_linear > 0.01:
		for i in audio_players.size():
			var a = audio_players[i]
			if not a.playing:
				a.stream = get_sfx(sfx_name)
				a.global_position = position
				a.pitch_scale = pitch + randf_range(-pitch_variation, pitch_variation)
				volume_linear *= clamp(1 - Globals.get_camera_zoom(), .05, 1.0)
				a.volume_db = linear2db(volume_linear)
#				a.max_distance = 700 * Globals.get_camera_zoom()
				a.play()
				# A little hack to work around bug with playing property:
				audio_players.remove_at(i)
				audio_players.append(a)
				break


func get_sfx(sfx_name : String) -> AudioStream:
	var bank = sounds.get(sfx_name)
	if bank == null:
		bank = []
		sounds[sfx_name] = bank
		var path = "res://sound/"
		var dir = Directory.new()
		dir.open(path)
		dir.list_dir_begin()
		while true:
			var file_name = dir.get_next()
			
			if file_name == "":
				break
			elif file_name.match(sfx_name + "*.wav.import"):
				bank.append(ResourceLoader.load(path + file_name.left(-7), "AudioStreamSample"))
		dir.list_dir_end()
	return bank[randi() % bank.size()]
