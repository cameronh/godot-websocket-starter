extends Node

const PORT := 8080
const PROTO_NAMES := ["ludus"]

@onready var _remote_edit = $UI/Net/Options/Remote

var peer = WebSocketMultiplayerPeer.new()

func _init() -> void:
	peer.supported_protocols = PROTO_NAMES

func _ready() -> void:
	get_tree().paused = true

func _on_host_pressed() -> void:
	multiplayer.multiplayer_peer = null
	peer.create_server(PORT)

	if peer.get_connection_status() == WebSocketMultiplayerPeer.CONNECTION_DISCONNECTED:
		OS.alert("Failed to start websocket server on port %d" % PORT)
		return

	multiplayer.multiplayer_peer = peer
	print("Websocket server started on port %d" % PORT)

	start_game()

func _on_connect_pressed() -> void:
	multiplayer.multiplayer_peer = null
	peer.create_client("ws://" + _remote_edit.text + ":" + str(PORT))

	if peer.get_connection_status() == WebSocketMultiplayerPeer.CONNECTION_DISCONNECTED:
		OS.alert("Failed to start websocket client")
		return

	multiplayer.multiplayer_peer = peer
	print("Connected to server at %s:%d" % [_remote_edit.text, PORT])
	
	start_game()

func start_game() -> void:
	$UI.hide()
	get_tree().paused = false

	if multiplayer.is_server():
		change_level.call_deferred(load("res://src/level.tscn"))

func change_level(scene: PackedScene) -> void:
	var level = $Level
	for child in level.get_children():
		level.remove_child(child)
		child.queue_free()
	level.add_child(scene.instantiate())
