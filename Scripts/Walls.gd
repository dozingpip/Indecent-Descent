extends Spatial

var wall_height
# create a cube object that stretches between 2 vector points.
func makeCubeBetweenPoints(cube_index, pointA, pointB):
	var between = pointB - pointA
	var cube = get_child(cube_index)
	cube.look_at(between, Vector3(0, -1, 0))
	cube.set_scale(Vector3(1, wall_height, between.length()/2))
	cube.set_translation(pointA + (between/2) +Vector3(0, wall_height/2, 0))

# make a box out of 4 cubes, using 4 vectors as points of the individual cubes
func makeWalls(point0, point1, point2, point3, _wall_height):
	wall_height = _wall_height
	makeCubeBetweenPoints(0, point0, point1)
	makeCubeBetweenPoints(1, point1, point2)
	makeCubeBetweenPoints(2, point2, point3)
	makeCubeBetweenPoints(3, point0, point3)