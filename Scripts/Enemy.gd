extends ImmediateGeometry

var laser

var vertical_tracking_range = 2

var tracking_width = 0.05

var firing_width = 0.5

var lock_on_time = 3

var fire_time = 1.5

var fire_length = 0.2

var laser_length = 40

var laser_timer

var num_level = 0

var player

var player_loc

var points = [Vector3(0,0,0), Vector3(0,0,0)]

var tracking_material = load("res://Materials/tracking_material.tres")
var firing_material = load("res://Materials/firing_material.tres")
var laser_width = tracking_width

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

	lock_on_time *= 1 - ((0.05) * sqrt(num_level))

	laser_timer = 0
	
	player = get_tree().get_nodes_in_group("Player")[0]
	points[0] = get_translation()

func _physics_process(delta):
	player_loc = player.get_translation()
	if (player_loc.y < to_global(get_translation()).y + vertical_tracking_range and player_loc.y > to_global(get_translation()).y - vertical_tracking_range):
		laser = true
		laser_timer += delta
		if(laser_timer >= lock_on_time):
			set_material_override(firing_material)
			if(laser_timer >= lock_on_time + fire_time):
				laser_width = firing_width
				var direction = points[1] - points[0]
				if $RayCast.is_colliding():
					var collider = $RayCast.get_collider()
					if collider.is_in_group("Player"):
						print("pew")
						player.take_damage(1)
						player.knockback(direction)
				if(laser_timer >= lock_on_time + fire_time + fire_length):
					laser_timer = 0
		else:
			laser_width = tracking_width
			var target_position = to_local(player.get_translation())
			var direction = target_position - points[0]
			$RayCast.set_cast_to(to_local(player_loc))
			direction = direction.normalized() * laser_length
			target_position = direction + points[0]
			points[1] = target_position
			set_material_override(tracking_material)
	else:
		laser_timer = 0;
		laser = false;
	if laser:
		draw()
