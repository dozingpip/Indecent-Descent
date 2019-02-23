extends ImmediateGeometry

var laser

var verticalTrackingRange = 2

var trackingWidth = 0.05

var firingWidth = 0.5

var lockOnTime = 3

var fireTime = 1.5

var fireLength = 0.2

var laserLength = 40

var laserTimer

var num_level = 0

var player

var player_loc

var points = [Vector3(0,0,0), Vector3(0,0,0)]

var tracking_material = load("res://Materials/tracking_material.tres")
var firing_material = load("res://Materials/firing_material.tres")
var laser_width = trackingWidth

func draw():
	clear()
	begin(Mesh.PRIMITIVE_TRIANGLE_STRIP)
	var camera = to_local(get_viewport().get_camera().get_translation())
	var offset = laser_width *((points[0]-camera).cross((points[1] - points[0])).normalized())
	add_vertex(points[0]+offset)
	add_vertex(points[0]-offset)
	add_vertex(points[1]+offset)
	add_vertex(points[1]-offset)
	end()

func _ready():
	laser = false

	lockOnTime *= 1 - ((0.05) * sqrt(num_level))

	laserTimer = 0
	
	player = get_tree().get_nodes_in_group("Player")[0]
	points[0] = get_translation()

func _physics_process(delta):
	player_loc = player.get_translation()
	if (player_loc.y < to_global(get_translation()).y + verticalTrackingRange and player_loc.y > to_global(get_translation()).y - verticalTrackingRange):
		laser = true
		laserTimer += delta
		if(laserTimer >= lockOnTime):
			set_material_override(firing_material)
			if(laserTimer >= lockOnTime + fireTime):
				laser_width = firingWidth
				var direction = points[1] - points[0]
				if $RayCast.is_colliding():
					var collider = $RayCast.get_collider()
					if collider.is_in_group("Player"):
						print("pew")
						player.takeDamage(1)
						player.knockback(direction)
				if(laserTimer >= lockOnTime + fireTime + fireLength):
					laserTimer = 0
		else:
			laser_width = trackingWidth
			var targetPosition = to_local(player.get_translation())
			var direction = targetPosition - points[0]
			$RayCast.set_cast_to(to_local(player_loc))
			direction = direction.normalized() * laserLength
			targetPosition = direction + points[0]
			points[1] = targetPosition
			set_material_override(tracking_material)
	else:
		laserTimer = 0;
		laser = false;
	if laser:
		draw()
