extends PathFollow2D

@export var speed := 200.0

func _physics_process(delta: float) -> void:
	offset += speed * delta
