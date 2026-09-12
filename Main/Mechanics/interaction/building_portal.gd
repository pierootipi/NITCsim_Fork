class_name BuildingPortal
extends Resource

## The interior scene to load when the player enters this building.
@export var interior_scene: PackedScene

## Name of the Marker2D inside interior_scene where the player
## should spawn when entering (matched via find_child at runtime).
@export var entrance_marker_name: String = ""
