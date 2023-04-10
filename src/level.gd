extends Node2D

func _ready() -> void:
	if !multiplayer.is_server():
		return

	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(del_player)

	# Spawn already connected players
	for id in multiplayer.get_peers():
		add_player(id)

	# Spawn the local player unless this is a dedicated server export.
	if !OS.has_feature("dedicated_server"):
		add_player(1)

func _exit_tree() -> void:
	if !multiplayer.is_server():
		return
	
	multiplayer.peer_connected.disconnect(add_player)
	multiplayer.peer_disconnected.disconnect(del_player)

func add_player(id: int):
	var character = preload("res://src/player/player.tscn").instantiate()
	character.player = id

	var pos := Vector2(100 * randf() * 2, 100 * randf() * 2)
	character.position = pos
	character.name = str(id)
	character.get_node("Name").set_text(character.name)
	$Players.add_child(character, true)

func del_player(id: int):
	if !$Players.has_node(str(id)):
		return

	$Players.get_node(str(id)).queue_free()
