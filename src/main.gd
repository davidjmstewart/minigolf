extends Node

var state
enum {FREE_LOOK, FREE_ROAM, SHOT_SETUP, SHOT_IN_PROGRESS, IN_MENU, HOLE_COMPLETE, GAME_COMPLETE} # Game states

var powerScale = 100

func _ready():
	change_state(FREE_LOOK)
	
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

var power = 0
	
func _process(delta):
	if Input.is_action_just_pressed('ui_accept'): # debugging: development test feature - press enter to reload the scene
		get_tree().reload_current_scene()
	match state:
		FREE_LOOK:
			power = 0
		SHOT_SETUP:
			power+=1
			$ShotMarker.transform.origin = $GolfBall.transform.origin

func _input(event):
	if event is InputEventMouseMotion: # if the user moved the mouse
		match state:
			FREE_LOOK: # if user moved mouse and we are in free look mode, adjust view accordingly
				$CameraSpatial.mouse_rotation(event) # rotate the camera's spatial parent (camera rotates with it)
			SHOT_SETUP: # if user moved mouse and we are in free look mode, adjust view accordingly
				$CameraSpatial.mouse_rotation(event) # rotate the camera's spatial parent (camera rotates with it)	
				#$ShotMarker.rotation = $CameraSpatial.rotation
				print("z: " + str($ShotMarker.rotation))

				$ShotMarker.rotation.y = $CameraSpatial.rotation.y

				print(str(event.relative.y))
				$ShotMarker.scale.z -= event.relative.y / 100
				if $ShotMarker.scale.z > 3:
					$ShotMarker.scale.z = 3
				elif $ShotMarker.scale.z < 0:
					$ShotMarker.scale.z = 0
				
	if event.is_action_pressed('click'):
		match state:
			FREE_LOOK:
				change_state(SHOT_SETUP)
				$CameraSpatial.disable_rotation_axis('x') #ensure we only do left-right rotation as the user sets up their shot
				print('click: going to   SHOT_SETUP')
				
	if event.is_action_released('click'):
		match state:
			SHOT_SETUP:
				change_state(FREE_LOOK) # TODO: change of state depends on if the user had any power selected for their shot: If they release the click and they have power selected, then we should actually move to SHOT_IN_PROGRESS, and then FREE_LOOK based on the outcome of SHOT_IN_PROGRESS
				$CameraSpatial.enable_rotation_axis('x') # allow the user to look around freely again
				print('release: going to FREE_LOOK')
				$GolfBall.shoot($CameraSpatial.rotation.y + PI, $ShotMarker.scale.z * powerScale)
				
			SHOT_IN_PROGRESS:
				$CameraSpatial.enable_rotation_axis('x') # allow the user to look around as the ball moves

				
func change_state(new_state):
	state = new_state
	match state:
		FREE_LOOK:
			$ShotMarker.hide()
		SHOT_SETUP:
			$ShotMarker.scale.z = 0
			$ShotMarker.show()