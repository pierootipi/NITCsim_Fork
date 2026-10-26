extends Node2D
class_name PlayableScene

@export var spawn_point: Marker2D 
var players := []

func _ready() -> void:
	
	load_data()

func set_player_position(player : Player , marker : Marker2D = spawn_point):
	if marker:
		player.global_position = marker.global_position

func add_player(player:Player):
	players.append(player)

func remove_player(player:Player):
	players.erase(player)

# functions to be changed for saving and loading scene data
func save_data():
	pass

func load_data():
	pass
