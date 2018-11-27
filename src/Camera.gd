extends Camera
func _ready():

	centre_ball()

"""
Centres the ball on the screen: x-axis rotation of the camera determined by how far
away from the ball the camera is
"""
func centre_ball():
	var translation = self.get_transform().origin
	var z_trans = translation.z # how for on the z-axis our camera is from the ball
	var y_trans = translation.y # how for on the y-axis our camera is from the ball
	var rotation = atan(y_trans/z_trans) # the initial rotation we will give our camera to ensure our ball is in the center of the screen

	rotate_object_local(Vector3(1, 0, 0), rotation) # then rotate around X axis (i.e. up-down motion)	