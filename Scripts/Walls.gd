extends Spatial


# make a box out of 4 cubes
func makeWalls(wall_height, width, length):
	$Wall0.set_translation(Vector3(-(width/2), 0, 0))
	$Wall0.set_scale(Vector3(1, wall_height, length))

	$Wall1.set_translation(Vector3((width/2), 0, 0))
	$Wall1.set_scale(Vector3(1, wall_height, length))

	$Wall2.set_translation(Vector3(0, 0, (length/2)))
	$Wall2.set_scale(Vector3(width, wall_height, 1))

	$Wall3.set_translation(Vector3(0, 0,-(length/2)))
	$Wall3.set_scale(Vector3(width, wall_height, 1))