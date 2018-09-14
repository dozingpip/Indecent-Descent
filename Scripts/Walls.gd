extends Spatial


# make a box out of 4 cubes, using 4 vectors as points of the individual cubes
func makeWalls(smallestX, smallestZ, midX, midZ, wall_height, length, width):
	$Wall0.set_translation(Vector3(smallestX, 0, smallestZ))
	#$Wall0.set_scale(Vector3(1, wall_height, length))
	
#	$Wall1.set_translation(Vector3(smallestX, 0, midZ))
#	$Wall1.set_scale(Vector3(1, wall_height, length))
#
#	$Wall2.set_translation(Vector3(midX, 0, smallestZ+width))
#	$Wall2.set_scale(Vector3(width, wall_height, 1))
#
#	$Wall3.set_translation(Vector3(midX, 0, smallestZ))
#	$Wall3.set_scale(Vector3(width, wall_height, 1))