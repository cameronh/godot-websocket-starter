extends CharacterBody2D

var speed := 200

# Set by the authority, synchronized on spawn
@export var player := 1 :
				set(id):
								player = id
								# Give authority over the player input to the appropriate peer
								$PlayerInput.set_multiplayer_authority(id)

@onready var input := $PlayerInput

func _ready() -> void:
	#if player == multiplayer.get_unique_id()

	#Let the client simulate player movement too to compensate network input latency.
	# set_physics_process(multiplayer.is_server())
	pass

func _physics_process(_delta: float) -> void:
	if input.attacking:
		$Shape.color = Color8(100, 100, 100, 255)
	else:
		$Shape.color = Color8(43, 86, 255, 255)
		
	input.attacking = false

	

	velocity = speed * input.direction

	move_and_slide()