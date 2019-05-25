tool
extends Spatial


export(String, "normal", "ice", "cracked", "sticky") var tile_type : String = "normal" setget set_type
var cracking_timer : float = 0

func set_type(new_value):
	tile_type = new_value
	if (Engine.is_editor_hint()):
		set_material("res://Materials/"+tile_type+"_tile.tres")
		self.add_to_group(tile_type)

func _ready():
	set_material("res://Materials/"+tile_type+"_tile.tres")
	self.add_to_group(tile_type)
	set_physics_process(false)

func set_material(file_name):
	$Cube.set_surface_material(0, load(file_name))

func start_cracking():
	set_physics_process(true)

func _physics_process(delta):
	cracking_timer += delta
	if cracking_timer > 2:
		queue_free()
	elif cracking_timer > 1:
		set_material("res://Materials/cracked_tile1.tres")