extends Node2D
class_name Building

@export var is_enterable: bool = false
@export var  portal : BuildingPortal
@export var exit_point : Marker2D


@onready var doors: InteractionBox = $Doors

func _ready() -> void:
	if portal:
		doors.target_scene_packed = portal.interior_scene
		doors.door_name = portal.entrance_marker_name

	doors.entered.connect(_on_doors_entered)

func _on_doors_entered(_body: Player) -> void:
	if exit_point:
		GameState.pending_exit_marker = exit_point.name
