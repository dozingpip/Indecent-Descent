extends KinematicBody

export(int) var normal_speed = 2
signal add_point
var lateral_speed_while_falling = normal_speed/2
var speed = normal_speed

var gravity = 10

var health = 5

var jump_speed = -4

var anim_speed = 0.125

var knockbackStunLength = 0.1

var knockbackSpeed = 0.25

var ice_friction = 4

var terminalVelocity = 7

var anim_timer

var knockbackStunTimer

var knockbackDirection = Vector3(0, 0, 0)

var jumping
enum FloorType{Normal, Ice, Sticky, Cracked, None}

var standingOn = []
var velocity = Vector3()

func _ready():
	anim_timer = anim_speed
	knockbackStunTimer = 0

func get_input(delta):
	var jump = Input.is_action_pressed("ui_accept")
	var left = Input.is_action_pressed("ui_left")
	var right = Input.is_action_pressed("ui_right")
	var up = Input.is_action_pressed("ui_up")
	var down = Input.is_action_pressed("ui_down")
	
	if is_on_floor() and jump:
		velocity.y -= jump_speed
	
	if !is_on_floor():
		speed = lateral_speed_while_falling
	else:
		speed = normal_speed
	
	if Input.is_action_just_pressed("ui_left"):
		$Sprite3D.set_frame(2)
		$Sprite3D.set_flip_h(false)
	if left:
		if velocity.x > -terminalVelocity:
			velocity.x -=speed
		anim_timer+=delta
		if(anim_timer>anim_speed):
			$Sprite3D.set_frame(2 if $Sprite3D.get_frame() == 3 else 3)
			anim_timer = 0
	
	if Input.is_action_just_pressed("ui_right"):
		$Sprite3D.set_frame(2)
		$Sprite3D.set_flip_h(true)
	
	if right:
		if velocity.x < terminalVelocity:
			velocity.x +=speed
		anim_timer+=delta
		if(anim_timer > anim_speed):
			$Sprite3D.set_frame(2 if $Sprite3D.get_frame() == 3 else 3)
			anim_timer = 0
	
	if up:
		if velocity.z > -terminalVelocity:
			velocity.z -= speed
		$Sprite3D.set_frame(1)
		anim_timer+= delta
		if(anim_timer >= anim_speed):
			$Sprite3D.set_flip_h(!$Sprite3D.is_flipped_h())
			anim_timer = 0
	
	if down:
		if velocity.z < terminalVelocity:
			velocity.z += speed
		$Sprite3D.set_frame(0)
		anim_timer+= delta
		if(anim_timer >= anim_speed):
			$Sprite3D.set_flip_h(!$Sprite3D.is_flipped_h())
			anim_timer = 0
	
	if !left and !right:
		velocity.x = 0
	if !up and !down:
		velocity.z = 0

func _physics_process(delta):
	if velocity.y > -terminalVelocity:
		velocity.y -= gravity * delta
	get_input(delta)
	
	for i in $Area.get_overlapping_bodies():
		var tile_collided = i.get_parent()
		if is_on_floor():
			if tile_collided.is_in_group("ice"):
				velocity.x = clamp(velocity.normalized().x * ice_friction, -speed *1.5, speed*1.5)
				velocity.z = clamp(velocity.normalized().z * ice_friction, -speed *1.5, speed *1.5)
			elif tile_collided.is_in_group("cracked"):
				tile_collided.cracking_timer += delta
				
				if tile_collided.cracking_timer > 2:
					tile_collided.queue_free()
				elif tile_collided.cracking_timer > 1:
					tile_collided.set_material("res://Materials/cracked_tile1.tres")
			elif tile_collided.is_in_group("sticky"):
				velocity/=2
	
	for i in $Area.get_overlapping_areas():
		print(i)
		if i.get_parent().is_in_group("collectible"):
			emit_signal("add_point")
			i.get_parent().queue_free()
		
	velocity = move_and_slide(velocity, Vector3(0, 1, 0))