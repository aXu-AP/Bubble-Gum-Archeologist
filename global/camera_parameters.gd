class_name CameraParameters
extends Resource

enum CameraMode {
	fixed,
	follow,
}

@export var mode : CameraMode = CameraMode.fixed
@export_node_path(Node2D) var target_path
@export var offset := Vector2.ZERO
@export var zoom := 1.0

var target : Node2D
