extends Node2D

@onready var scenes: Node2D = $Scenes
@export var start_scene : PackedScene = preload("res://Scenes/main_world.tscn")

var instances : Dictionary = {}

# player of client
var local_player : Player

func _ready() -> void:
	y_sort_enabled = true
	var players := Node2D.new()
	players.name = "Players"
	players.y_sort_enabled = true
	add_child(players)
	
	scenes = get_node_or_null("Scenes")
	
	# null check
	if scenes == null:
		scenes = Node2D.new()
		scenes.name = "Scenes"
		add_child(scenes)
		
	
	# change_scene(start_scene)
	var main_scene = start_scene.instantiate()
	add_child(main_scene)
	instances[start_scene.resource_path] = main_scene

# process to load players belonging top same scene as the local_players scene
func _process(delta: float) -> void:
	
	if local_player == null : return
	var local_player_scene := local_player.curr_scene
	
	# visibility and activation of scenes
	for path in instances:
		_set_scene_active(instances[path], local_player_scene == path)
	
	# rendering players in same scene and dealing collision boxes
	for player in $Players.get_children():
		var is_same = (player.curr_scene == local_player_scene)
		player.visible = is_same
		player.find_child("Hitbox").set_deferred("disabled", not is_same)

func _set_scene_active(scene: Node2D, active: bool) -> void:
	if scene.visible == active: return            
	scene.visible = active
	scene.process_mode = Node.PROCESS_MODE_INHERIT if active else Node.PROCESS_MODE_DISABLED
	for layer in scene.find_children("*", "TileMapLayer", true, false):
		layer.collision_enabled = active

func change_scene(player : Player, scene: Variant,door : String = "") -> void:
	# Resolve input into a PackedScene regardless of what was passed
	var packed_scene: PackedScene
	
	if scene is String:
		packed_scene = load(scene)
	elif scene is PackedScene:
		packed_scene = scene
	else:
		push_error("change_scene() expects a String path or a PackedScene, got: %s" % typeof(scene))
		return
	
	if packed_scene == null:
		push_error("Failed to load scene: %s" % scene)
		return
	
	exit_scene(player)
	
	var new_scene = instances.get(packed_scene.resource_path)
	if not new_scene:
		new_scene = packed_scene.instantiate()
		scenes.add_child(new_scene)
		instances[new_scene.scene_file_path] = new_scene
	
	
	if new_scene is PlayableScene:
		new_scene.add_player(player)
		player.curr_scene = new_scene.scene_file_path
		if door == "":
			new_scene.set_player_position(player)
		else:
			var exit_point = new_scene.find_child(door,true,false)
			if exit_point is Marker2D:
				new_scene.set_player_position(player,exit_point)
			else:
				new_scene.set_player_position(player)

func exit_scene(player:Player):
	if !multiplayer.is_server(): return
	
	var scene = instances.get(player.curr_scene)
	if scene == null || scene == self : return
	
	var scene_in_instances = instances.find_key(scene.scene_file_path)
	
	if scene_in_instances == null : return
	
	scene_in_instances.remove_player(player)
	
	if scene_in_instances.players.size() == 0:
		instances.erase(scene_in_instances.scene_file_path)
		scene_in_instances.save_data()
		scene_in_instances.queue_free()
		await get_tree().process_frame
	
	pass

func get_spawn_point() -> Vector2 :
	var scene = instances.get(start_scene.resource_path)
	if scene is PlayableScene and scene.spawn_point :
		return scene.spawn_point.global_position
	return Vector2.ZERO
