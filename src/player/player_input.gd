extends MultiplayerSynchronizer

@export var attacking := false

@export var direction := Vector2()

func _ready() -> void:
	# Only process for the local player.
	set_process(get_multiplayer_authority() == multiplayer.get_unique_id())

func _process(_delta: float) -> void:
	direction = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	)
	if direction.length() > 1.0:
		direction = direction.normalized()

	if Input.is_action_just_pressed("ui_accept"):
		attack.rpc()

@rpc("call_local")
func attack():
	attacking = true
