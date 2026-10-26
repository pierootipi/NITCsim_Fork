extends MultiplayerSpawner

@export var network_player : PackedScene

func _ready() -> void:
	add_spawnable_scene(network_player.resource_path)
	multiplayer.peer_connected.connect(spawn_player)
	multiplayer.peer_disconnected.connect(despawn_player)

func spawn_player(id:int):
	if !multiplayer.is_server(): return
	
	var player : Node = network_player.instantiate()
	player.name = str(id)
	player.global_position = WorldManager.get_spawn_point()
	
	get_node(spawn_path).call_deferred("add_child",player)


func despawn_player(id: int) -> void:
	if !multiplayer.is_server(): return
	var n := get_node(spawn_path).get_node_or_null(str(id))
	
	# must remove from node from scene
	if n: n.queue_free()
