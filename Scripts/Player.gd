extends KinematicBody

# signals
signal add_point
signal crack

# lateral-speed
export(int) var normal_speed = 10
var lateral_speed_while_falling = normal_speed/2
var speed = normal_speed

# falling/ jumping
var gravity = 3
var terminal_velocity = 9
var y_velocity = 0
var jump_speed = 40

var health = 5

var anim_speed = 0.125

# knockback
var knockback_stun_length = 0.1
var knockback_speed = 0.25
var knockback_stun_timer
var knockback_direction = Vector3(0, 0, 0)

var ice_friction = 4

var anim_timer

enum FloorType{Normal, Ice, Sticky, Cracked, None}

func knockback(direction):
	knockback_stun_timer = knockback_stun_length
	knockback_direction = direction.normalized()

func take_damage(amount):
	if(knockback_stun_timer <= 0):
		health -= amount
		if (health <= 0):
			get_tree().get_node("World").game_over()

func _ready():
	anim_timer = anim_speed
	knockback_stun_timer = 0

func get_input():
	var input = {}
	input["jump"] = Input.is_action_pressed("ui_accept")
	input["left"] = Input.is_action_pressed("ui_left")
	input["right"] = Input.is_action_pressed("ui_right")
	input["up"] = Input.is_action_pressed("ui_up")
	input["down"] = Input.is_action_pressed("ui_down")
	return input

func animate(input, delta):
	if Input.is_action_just_pressed("ui_right"):
		$Sprite3D.set_frame(2)
		$Sprite3D.set_flip_h(true)
	if input["right"]:
		anim_timer+=delta
		if(anim_timer > anim_speed):
			$Sprite3D.set_frame(2 if $Sprite3D.get_frame() == 3 else 3)
			anim_timer = 0
	
	if Input.is_action_just_pressed("ui_left"):
		$Sprite3D.set_frame(2)
		$Sprite3D.set_flip_h(false)
	if input["left"]:
		anim_timer+=delta
		if(anim_timer>anim_speed):
			$Sprite3D.set_frame(2 if $Sprite3D.get_frame() == 3 else 3)
			anim_timer = 0
	
	if input["down"]:
		$Sprite3D.set_frame(0)
		anim_timer+= delta
		if(anim_timer >= anim_speed):
			$Sprite3D.set_flip_h(!$Sprite3D.is_flipped_h())
			anim_timer = 0
	
	if input["up"]:
		$Sprite3D.set_frame(1)
		anim_timer+= delta
		if(anim_timer >= anim_speed):
			$Sprite3D.set_flip_h(!$Sprite3D.is_flipped_h())
			anim_timer = 0

func calc_velocity(input):
	var velocity = Vector3()
	if is_on_floor() and input["jump"]:
		y_velocity += jump_speed
		
	if !is_on_floor():
		speed = lateral_speed_while_falling
	else:
		speed = normal_speed
	
	if input["right"]:
		velocity.x +=speed
	
	if input["left"]:
		velocity.x -=speed
	
	if input["down"]:
		velocity.z += speed
	
	if input["up"]:
		velocity.z -= speed
	
	if not is_on_floor() and y_velocity > -terminal_velocity:
		y_velocity -= gravity
	return Vector3(velocity.x, y_velocity, velocity.z)
	
func _physics_process(delta):
	var input = get_input()
	animate(input, delta)
	var velocity = calc_velocity(input)
	
	for i in $Area.get_overlapping_bodies():
		var tile_collided = i.get_parent()
		if is_on_floor():
			if tile_collided.is_in_group("ice"):
				velocity.x = clamp(velocity.normalized().x * ice_friction, -speed *1.5, speed*1.5)
				velocity.z = clamp(velocity.normalized().z * ice_friction, -speed *1.5, speed *1.5)
			elif tile_collided.is_in_group("cracked") and not is_connected("crack", tile_collided, "start_cracking"):
# warning-ignore:return_value_discarded
				connect("crack", tile_collided, "start_cracking")
				emit_signal("crack")
			elif tile_collided.is_in_group("sticky"):
				velocity/=2
	
	for i in $Area.get_overlapping_areas():
		if i.get_parent().is_in_group("collectible"):
			emit_signal("add_point")
			i.get_parent().queue_free()
	
	if (knockback_stun_timer > 0):
		translation += knockback_direction * knockback_speed
		knockback_stun_timer -= delta
	else:
		velocity = move_and_slide(velocity, Vector3(0, 1, 0))