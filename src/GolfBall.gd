extends RigidBody

var pos = Vector3(0, 0, 0)
var speed = 0.05

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	var movement = Vector3(0, 0, 0)
	
	if Input.is_key_pressed(KEY_W):
		movement = Vector3(movement.x, movement.y, movement.z + 1)
	if Input.is_key_pressed(KEY_A):
		movement = Vector3(movement.x + 1, movement.y, movement.z)
	if Input.is_key_pressed(KEY_S):
		movement = Vector3(movement.x , movement.y, movement.z - 1)
	if Input.is_key_pressed(KEY_D):
		movement = Vector3(movement.x - 1, movement.y, movement.z)

	pos = movement
	apply_impulse(Vector3(), movement * speed)

func shoot(angle, power):
	var force = Vector3(0, 0, -1).rotated(Vector3(0, 1, 0), angle)
	apply_impulse(Vector3(), force * power / 5)

func _integrate_forces(state):
	if state.linear_velocity.length() < 0.2:

		state.linear_velocity = Vector3()