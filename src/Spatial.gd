extends Spatial

# accumulators
var rot_x = 0 # left-right rotation (rotation about the Y-axis)
var rot_y = 0 # up-down rotation (rotation about the X-axis)
var LOOKAROUND_SPEED = 0.01
var zoom_speed = 0.05
var zoom = 0.5

enum {ENABLED, DISABLED}

var x_axis_rotation = ENABLED
var y_axis_rotation = ENABLED

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_WHEEL_UP:
			var translation = self.get_transform().origin
			zoom -= zoom_speed
			print('zoom up')
            # call the zoom function
        # zoom out
		if event.button_index == BUTTON_WHEEL_DOWN:
			zoom += zoom_speed
			print('zoom down')

func mouse_rotation(event):

	rot_x += event.relative.x * LOOKAROUND_SPEED

	

	transform.basis = Basis() # reset rotation

	if y_axis_rotation == ENABLED:
		rotate_object_local(Vector3(0, 1, 0), -rot_x) # first rotate around the Y axis (i.e. left-right motion)
	if x_axis_rotation == ENABLED:
		rot_y += event.relative.y * LOOKAROUND_SPEED	
		rot_y = clamp(rot_y, 0, PI/4) # ensure that we only rotate about the X axis by an amount between 0 and 45 degrees(values determined by trial and error)
	rotate_object_local(Vector3(1, 0, 0), rot_y) # then rotate around X axis (i.e. up-down motion)

		



			
func disable_rotation_axis(axis_to_disable):
	if axis_to_disable == 'x':
		x_axis_rotation = DISABLED
	elif axis_to_disable == 'y':
		y_axis_rotation = DISABLED
		
func enable_rotation_axis(axis_to_enable):
	if axis_to_enable == 'x':
		x_axis_rotation = ENABLED
	elif axis_to_enable == 'y':
		y_axis_rotation = ENABLED
		
func _process(delta):
	zoom = clamp(zoom, 0.1, 4)
	scale = Vector3(1, 1, 1) * zoom
	var ball = get_node("/root/Main/GolfBall")
	var ball_translation = ball.translation #get the position of the ball in global coordinates
	self.set_translation(ball_translation) # follow the ball  (set the position of our spatial node to the position of the ball)

func _enter_tree():
	"""
	Hide the mouse when we start
	"""
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _leave_tree():
	"""
	Show the mouse when we leave
	"""
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
