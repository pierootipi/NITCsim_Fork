extends Node2D
class_name Building

@export var is_enterable: bool = false

@onready var doors: InteractionBox = $Doors

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
