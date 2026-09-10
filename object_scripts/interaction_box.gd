extends Area2D
class_name InteractionBox


# Supports either an exported .tscn file or a PackedScene resource
@export_file("*.tscn") var target_scene_path: String = ""
@export var target_scene_packed: PackedScene

# Internal variable for scenes passed dynamically via code
var target_scene_override: Variant

@onready var trigger_shape: CollisionShape2D = $CollisionPolygon2D
@onready var wall_collider: CollisionShape2D = $StaticBody2D/CollisionPolygon2D

func _on_body_entered(body: Player) -> void:
	
	if target_scene_override is PackedScene:
		get_tree().change_scene_to_packed(target_scene_override)
		return
	elif target_scene_override is String:
		get_tree().change_scene_to_file(target_scene_path)
		return
	
	
	if target_scene_packed:
		get_tree().change_scene_to_packed(target_scene_packed)
	elif target_scene_path != "":
		get_tree().change_scene_to_file(target_scene_path)
