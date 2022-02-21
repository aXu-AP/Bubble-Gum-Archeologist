extends Node

@onready var stream_packs := {
	menu = [load("res://sound/menu.ogg")],
	explore = [load("res://sound/explore1.ogg"), load("res://sound/explore2.ogg"), load("res://sound/explore3.ogg")],
	panic = [load("res://sound/panic2.ogg")],
	victory = [load("res://sound/victory.ogg")]
}

var current_music := ""
var next_music := ""
var current_variant := 0
var next_variant := 0
var current_player := AudioStreamPlayer.new()
var next_player := AudioStreamPlayer.new()


func _ready() -> void:
	current_player.bus = "Music"
	next_player.bus = "Music"
	add_child(current_player)
	add_child(next_player)
	process_mode = Node.PROCESS_MODE_ALWAYS


func play_music(music : String, variant := 0) -> void:
	next_music = music
	next_variant = variant
	if current_music == next_music and current_variant != next_variant:
		next_player.stream = stream_packs[music][variant]
		next_player.volume_db = linear2db(0)
		next_player.play(current_player.get_playback_position())


func _process(delta: float) -> void:
	if current_music != next_music:
		var vol = move_toward(db2linear(current_player.volume_db), 0, delta / 2)
		current_player.volume_db = linear2db(vol)
		if vol < .01 or not stream_packs.has(current_music):
			current_music = next_music
			current_variant = next_variant
			current_player.stop()
			if stream_packs.has(current_music):
				current_player.volume_db = linear2db(1)
				current_player.stream = stream_packs[current_music][current_variant]
				current_player.play()
	if current_music == next_music and current_variant != next_variant:
		var vol = move_toward(db2linear(current_player.volume_db), 0, delta / 2)
		current_player.volume_db = linear2db(vol)
		next_player.volume_db = linear2db(1 - vol)
		if vol < .01:
			current_variant = next_variant
			current_player.stop()
			var temp = current_player
			current_player = next_player
			next_player = temp
