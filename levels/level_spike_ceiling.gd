extends LevelTemplate

func launch_trap(_area):
	$AnimationPlayer.play("spikes_fall")
	play_panic()
