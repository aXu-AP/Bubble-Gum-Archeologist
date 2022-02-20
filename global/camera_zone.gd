class_name CameraZone
extends Area2D

@export var zone_priority := 0
@export var parameters : Resource

func _ready() -> void:
	parameters.target = get_node(parameters.target_path)
