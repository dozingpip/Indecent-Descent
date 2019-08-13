extends Spatial

var light_dist_from_wall = 5
var light_height = 0.8

# make a box out of 4 cubes
func makeWalls(wall_height, width, length):
	$Wall0.set_translation(Vector3(-(width/2), 0, 0))
	$Wall0.set_scale(Vector3(1, wall_height, length))
	get_node("Wall0/Light").translate(Vector3(light_dist_from_wall, light_height, 0))

	$Wall1.set_translation(Vector3((width/2), 0, 0))
	$Wall1.set_scale(Vector3(1, wall_height, length))
	get_node("Wall1/Light").translate(Vector3(-light_dist_from_wall, light_height, 0))

	$Wall2.set_translation(Vector3(0, 0, (length/2)))
	$Wall2.set_scale(Vector3(width, wall_height, 1))
	get_node("Wall2/Light").translate(Vector3(0, light_height, -light_dist_from_wall))

	$Wall3.set_translation(Vector3(0, 0,-(length/2)))
	$Wall3.set_scale(Vector3(width, wall_height, 1))
	get_node("Wall3/Light").translate(Vector3(0, light_height, light_dist_from_wall))